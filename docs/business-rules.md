# business-rules

このドキュメントは、DB スキーマだけでは読み取れない業務上の意味を補うためのものです。  
初版は schema 名とカラム名から読み取れる範囲で整理しているため、確定情報と要確認情報を分けて扱ってください。

## AI 向けの前提

- 型定義だけで意味を断定しない
- `*_history`, `*_logs`, `*_snapshots` は履歴系テーブルの可能性が高く、現在値テーブルと混同しない
- `orders` と `order_history` は別物として扱う
- `items` は価格調整、トラフィック、外部ジョブの中心テーブル
- `accounts` は eBay 販売アカウントの中心テーブル
- `users` はアプリ利用者、`accounts` は販売アカウントという役割分担に見える
- `service_role` や各種 token カラムをアプリコードへ露出させない

## テーブル群ごとの用途

### 1. 受注・購入者

- `orders`
  - 現在の受注データの中心とみなす
  - 発送、利益、ケース対応の起点になる可能性が高い
- `order_line_items`
  - 受注明細
  - `orders.id` ではなく `orders.order_no` を参照しているため join 時に注意
- `buyers`
  - eBay 購入者マスタ
  - `message_history` は `buyers.id` ではなく `buyers.ebay_buyer_id` を参照する
- `order_history`
  - 履歴・スナップショット用途の可能性が高い
  - 最新状態の更新先かどうかはコード確認が必要

### 2. ケース対応

- `case_records`
  - ケース管理の親テーブル
  - `accounts`, `buyers`, `orders`, `users` と関係する
- `case_events`
  - ケースの時系列イベント
- `case_items`
  - 返金や対象商品を保持するケース明細
- `case_memos`
  - 社内向けメモ
  - 顧客に見せるデータとは限らない

### 3. 価格調整・販売最適化

- `traffic_metrics`
  - 商品の集計メトリクス
- `price_observations`
  - 相場観測や競合観測
- `price_recommendations`
  - 提案値。実価格そのものではない
- `price_change_logs`
  - 実行結果の監査ログ
- `markdown_presets` / `markdown_runs`
  - eBay markdown セールの設定と実行履歴

### 4. 発送・運送請求

- `shipment_groups`
  - 注文を発送単位にまとめる親テーブル
- `shipment_group_orders`
  - 発送と注文の中間テーブル
- `carrier_invoices`
  - 運送会社請求の親
- `carrier_shipments`
  - AWB 単位または配送単位の明細
- `carrier_charges`
  - 請求項目の詳細行
- `carrier_invoice_anomalies`
  - 請求異常の検知結果
- `carrier_charge_label_catalog`
  - 請求ラベル標準化辞書
- `carrier_unknown_charge_events`
  - 辞書未登録ラベルの発見履歴

### 5. 在庫・棚卸

- `inventory_units`
  - 個別在庫、または SKU 単位在庫の主要テーブル
- `inventory_locations`
  - 場所マスタ
- `inventory_statuses`
  - 状態マスタ
- `inventory_counts` / `inventory_count_lines`
  - 棚卸ヘッダと明細
- `inventory_management_schedules`
  - 在庫更新や棚卸のスケジュール
- `inventory_update_history`
  - 在庫更新バッチの履歴

## ステータスの意味

`baywork` のコード・ドキュメントから確認できた範囲では、以下の値が実際に業務ロジックで使われています。

| 対象 | カラム | 状態値 | 意味 / 扱い |
| --- | --- | --- | --- |
| `case_records` | `case_type` | `RETURN`, `INR` | ケース種別。返品 / 未着。 |
| `case_records` | `status` | `OPEN`, `ACTION_REQUIRED`, `ESCALATED`, `IN_PROGRESS`, `PENDING_SELLER` | 対応中として警告表示対象。 |
| `case_records` | `status` | `CLOSED`, `REFUNDED`, `CANCELLED` | 終了系ステータス。 |
| `case_events` | `event_type` | `BUYER_MESSAGE`, `SELLER_RESPONSE`, `AUTO_UPDATE` など | ケースイベント種別。追加値の可能性あり。 |
| `orders` | `shipping_status` | `UNSHIPPED`, `READY`, `RESERVED`, `SHIPPED` | 発送業務の主要状態。UI がこの値でタブ分岐する。 |
| `orders` | `purchase_msg_status`, `shipped_msg_status`, `delivered_msg_status` | `SENT` など | 自動メッセージ送信成功時に `SENT` を入れる設計。 |
| `shipment_groups` | `status` | `draft`, `ready`, `shipped` | 同梱グループ状態。`shipped` は編集不可。 |
| `inventory_counts` | `status` | `draft`, `frozen`, `closed` | 棚卸セッション状態。`draft` のみ編集可。 |
| `inventory_units` | `status_code` | `in_stock`, `returned`, `cancel_stock`, `domestic_sale` | 棚卸理論在庫の集計対象になる在庫状態。 |
| `markdown_runs` | `status` | `success`, `failed` | markdown 実行結果。 |
| `account_health_snapshots` | `seller_level`, `shipping_level` など | eBay API 由来の文字列 | eBay アカウント評価状態。 |

## 特殊値・実装上の注意

- `buyers.ebay_buyer_id`
  - `message_history` の join キーとして使われる
- `inventory_locations.code`
  - `inventory_counts`, `inventory_units` の参照先
  - `id` ではなく `code` が業務キーになっている
- `octoparse_tasks.task_id`
  - `inventory_management_schedules` の参照先
  - 数値主キー `id` ではない点に注意
- `orders.order_no`
  - `order_line_items` の参照先
  - `orders.id` と混同しない
- `inventory_counts`
  - `draft` のときだけ行更新や再計算が可能
  - `freeze` 後は入力ロック、`close` 後は確定済みスナップショットとして扱う
- `inventory_units.status_code`
  - 棚卸の理論在庫に含めるのは `in_stock`, `returned`, `cancel_stock`, `domestic_sale`
- `shipment_groups`
  - 同じ `ebay_buyer_id` の注文だけを同梱対象にできる
  - 2件未満になるとグループ自体を削除する実装
  - `shipped` 後は変更不可
- `orders.shipping_status`
  - `READY` は発送準備完了の中間状態として使われる
  - 発送後メッセージ送信は `SHIPPED` を契機に動く設計
- `accounts.access_token`, `accounts.refresh_token`, `octoparse_accounts.password`
  - 機密情報として扱う
  - AI に内容を渡さない

## AI に誤解してほしくないこと

- 参照制約が無いから未使用とは限らない
- `history`, `logs`, `snapshots` は削除してよい候補ではない
- トークンやパスワードを含むカラムは分析対象でも出力対象でもない
- 価格提案テーブルと実価格テーブルは分けて扱う
- `test` テーブルは本当に不要か未確認なので勝手に削除候補にしない

## 追記が必要な項目

- 受注 `status` の列挙値と意味
- Webhook `event_type` の運用一覧
- eBay アカウント健全性指標の運用ルール
