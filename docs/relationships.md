# relationships

`public` schema の外部キー関係を整理したドキュメントです。  
初版は migration `20260325020955_remote_schema.sql` の制約定義を元に作成しています。

## 重要な見方

- `ON DELETE CASCADE` のテーブルは親削除時に子が消える
- `ON DELETE SET NULL` のテーブルは親削除時に参照だけ外れる
- 外部キーがなくても業務上依存している場合があるため、必要に応じて追記する

## アカウント・ユーザー周り

| 親テーブル | 子テーブル | キー | 関係 | 削除時の影響 | 備考 |
| --- | --- | --- | --- | --- | --- |
| `accounts` | `account_health_snapshots` | `account_id -> accounts.id` | 1:N | 親削除で snapshot も削除 | 健全性履歴 |
| `users` | `daily_memos` | `user_id -> users.id` | 1:N | 親削除で memo も削除 | 日次メモ |
| `users` | `employees` | `user_id -> users.id` | 1:N | 削除動作は明示なし | 要運用確認 |
| `users` | `fixed_costs` | `user_id -> users.id` | 1:N | 親削除で固定費も削除 | 個人単位の固定費 |
| `users` | `name_map` | `user_id -> users.id` | 1:N | 削除動作は明示なし | 名寄せ辞書 |
| `users` | `priority_quadrants` | `user_id -> users.id` | 1:N | 親削除でタスクも削除 | 個人タスク |
| `users` | `inventory_management_schedules` | `user_id -> users.id` | 1:N | 削除動作は明示なし | スケジュール管理 |

## 購入者・受注・ケース

| 親テーブル | 子テーブル | キー | 関係 | 削除時の影響 | 備考 |
| --- | --- | --- | --- | --- | --- |
| `buyers` | `orders` | `buyer_id -> buyers.id` | 1:N | 親削除で注文も削除 | `buyer_id_fk` |
| `buyers` | `case_records` | `buyer_id -> buyers.id` | 1:N | 親削除で `buyer_id` が `NULL` | ケースは残る |
| `buyers` | `message_history` | `ebay_buyer_id -> buyers.ebay_buyer_id` | 1:N | 削除動作は明示なし | 数値 ID ではなく eBay buyer id |
| `accounts` | `case_records` | `account_id -> accounts.id` | 1:N | 親削除でケースも削除 | アカウント別ケース |
| `users` | `case_records` | `assignee_user_id -> users.id` | 1:N | 親削除で担当者が `NULL` | 担当者アサイン |
| `orders` | `case_records` | `order_id -> orders.id` | 1:N | 親削除で `order_id` が `NULL` | ケースは残る |
| `orders` | `order_line_items` | `order_no -> orders.order_no` | 1:N | 親削除で line item も削除 | `id` ではなく `order_no` 参照 |
| `case_records` | `case_events` | `case_id -> case_records.id` | 1:N | 親削除で event も削除 | ケースイベント |
| `case_records` | `case_items` | `case_id -> case_records.id` | 1:N | 親削除で item も削除 | ケース対象明細 |
| `case_records` | `case_memos` | `case_id -> case_records.id` | 1:N | 親削除で memo も削除 | ケース内部メモ |
| `order_line_items` | `case_items` | `order_line_item_id -> order_line_items.id` | 1:N | 親削除で参照が `NULL` | 注文明細との紐付け |
| `users` | `case_memos` | `author_user_id -> users.id` | 1:N | 親削除で作成者が `NULL` | 作者情報のみ切れる |

## 商品・価格・トラフィック

| 親テーブル | 子テーブル | キー | 関係 | 削除時の影響 | 備考 |
| --- | --- | --- | --- | --- | --- |
| `items` | `openclaw_jobs` | `item_id -> items.id` | 1:N | 親削除で job も削除 | 商品単位ジョブ |
| `items` | `traffic_history` | `item_id -> items.id` | 1:N | 削除動作は明示なし | 履歴は残る可能性あり |
| `items` | `traffic_metrics` | `item_id -> items.id` | 1:N | 親削除で metrics も削除 | 集計指標 |
| `items` | `price_observations` | `item_id -> items.id` | 1:N | 親削除で observation も削除 | 相場観測 |
| `items` | `price_recommendations` | `item_id -> items.id` | 1:N | 親削除で recommendation も削除 | 価格提案 |
| `items` | `price_change_logs` | `item_id -> items.id` | 1:N | 親削除で log も削除 | 価格変更履歴 |
| `traffic_metrics` | `price_recommendations` | `metric_id -> traffic_metrics.id` | 1:N | 親削除で `metric_id` が `NULL` | 推奨元データ |
| `price_observations` | `price_recommendations` | `observation_id -> price_observations.id` | 1:N | 親削除で `observation_id` が `NULL` | 相場観測との紐付け |
| `price_recommendations` | `price_change_logs` | `recommendation_id -> price_recommendations.id` | 1:N | 親削除で `recommendation_id` が `NULL` | 実行履歴は残る |
| `openclaw_jobs` | `price_change_logs` | `openclaw_job_id -> openclaw_jobs.id` | 1:N | 親削除で `openclaw_job_id` が `NULL` | 外部実行履歴 |
| `accounts` | `markdown_presets` | `account_id -> accounts.id` | 1:N | 親削除で preset も削除 | アカウント別セール設定 |
| `accounts` | `markdown_runs` | `account_id -> accounts.id` | 1:N | 親削除で run も削除 | 実行履歴 |
| `markdown_presets` | `markdown_runs` | `preset_id -> markdown_presets.id` | 1:N | 親削除で `preset_id` が `NULL` | 実行履歴は残る |

## 発送・請求

| 親テーブル | 子テーブル | キー | 関係 | 削除時の影響 | 備考 |
| --- | --- | --- | --- | --- | --- |
| `carrier_invoices` | `carrier_shipments` | `invoice_id -> carrier_invoices.id` | 1:N | 親削除で shipment も削除 | 請求ヘッダ配下 |
| `carrier_invoices` | `carrier_invoice_anomalies` | `invoice_id -> carrier_invoices.id` | 1:N | 親削除で anomaly も削除 | 請求監査 |
| `carrier_invoices` | `carrier_unknown_charge_events` | `invoice_id -> carrier_invoices.id` | 1:N | 親削除で event も削除 | 未知請求イベント |
| `carrier_shipments` | `carrier_charges` | `shipment_id -> carrier_shipments.id` | 1:N | 親削除で charge も削除 | 請求明細 |
| `carrier_shipments` | `carrier_invoice_anomalies` | `shipment_id -> carrier_shipments.id` | 1:N | 親削除で anomaly も削除 | 配送明細単位の異常 |
| `carrier_shipments` | `carrier_unknown_charge_events` | `shipment_id -> carrier_shipments.id` | 1:N | 親削除で event も削除 | 配送明細単位の未知請求 |
| `carrier_charge_label_catalog` | `carrier_unknown_charge_events` | `catalog_id -> carrier_charge_label_catalog.id` | 1:N | 親削除で `catalog_id` が `NULL` | 正規化辞書 |
| `shipment_groups` | `shipment_group_orders` | `group_id -> shipment_groups.id` | 1:N | 親削除で関連行も削除 | グループと注文の中間 |

## 在庫・棚卸・外部連携

| 親テーブル | 子テーブル | キー | 関係 | 削除時の影響 | 備考 |
| --- | --- | --- | --- | --- | --- |
| `inventory_counts` | `inventory_count_lines` | `inventory_count_id -> inventory_counts.id` | 1:N | 親削除で明細も削除 | 棚卸ヘッダと明細 |
| `inventory_locations` | `inventory_counts` | `location_code -> inventory_locations.code` | 1:N | 削除動作は明示なし | `id` ではなく `code` を参照 |
| `inventory_locations` | `inventory_units` | `location_code -> inventory_locations.code` | 1:N | 削除動作は明示なし | 在庫保管場所 |
| `inventory_statuses` | `inventory_units` | `status_code -> inventory_statuses.code` | 1:N | 削除動作は明示なし | 在庫状態辞書 |
| `octoparse_tasks` | `inventory_management_schedules` | `task_id -> octoparse_tasks.task_id` | 1:N | 削除動作は明示なし | Octoparse タスク連携 |
| `employees` | `name_map` | `employee_id -> employees.id` | 1:N | 親削除で名寄せも削除 | 名寄せ辞書 |
| `sheet_conversion_jobs` | `sheet_conversion_job_items` | `job_id -> sheet_conversion_jobs.id` | 1:N | 親削除で行詳細も削除 | ジョブ実行詳細 |
| `accounts` | `webhooks` | `account_id -> accounts.id` | 1:N | 親削除で webhook も削除 | アカウント別通知設定 |

## マネージャー・目標管理

| 親テーブル | 子テーブル | キー | 関係 | 削除時の影響 | 備考 |
| --- | --- | --- | --- | --- | --- |
| `users` | `manager_goals` | `user_id -> users.id` | 1:N | 親削除で goal も削除 | 目標の親はユーザー |
| `manager_goals` | `manager_kpis` | `goal_id -> manager_goals.id` | 1:N | 親削除で KPI も削除 | KPI は goal 従属 |
| `users` | `manager_kpis` | `user_id -> users.id` | 1:N | 親削除で KPI も削除 | 直接 user にも紐づく |
| `manager_goals` | `manager_plans` | `goal_id -> manager_goals.id` | 1:N | 親削除で plan も削除 | 実行計画 |
| `users` | `manager_plans` | `user_id -> users.id` | 1:N | 親削除で plan も削除 | 作成主体 |
| `users` | `manager_plans` | `owner_user_id -> users.id` | 1:N | 親削除で owner が `NULL` | 担当者アサイン |
| `users` | `manager_tasks` | `user_id -> users.id` | 1:N | 親削除で task も削除 | タスクの主体 |
| `items` | `manager_tasks` | `item_id -> items.id` | 1:N | 親削除で `item_id` が `NULL` | 商品起点タスク |
| `orders` | `manager_tasks` | `order_id -> orders.id` | 1:N | 親削除で `order_id` が `NULL` | 注文起点タスク |
| `manager_goals` | `manager_tasks` | `related_goal_id -> manager_goals.id` | 1:N | 親削除で `related_goal_id` が `NULL` | 関連目標 |
| `manager_kpis` | `manager_tasks` | `related_kpi_id -> manager_kpis.id` | 1:N | 親削除で `related_kpi_id` が `NULL` | 関連 KPI |
| `manager_plans` | `manager_tasks` | `related_plan_id -> manager_plans.id` | 1:N | 親削除で `related_plan_id` が `NULL` | 関連 plan |
| `manager_tasks` | `manager_task_schedules` | `task_id -> manager_tasks.id` | 1:N | 親削除で schedule も削除 | 予定管理 |

## 外部キーが薄いが中心と見られるテーブル

- `orders`
- `items`
- `accounts`
- `users`
- `carrier_invoices`
- `case_records`

これらは親として参照される一方で、すべての依存が FK 化されているとは限りません。アプリケーションコードで追加の join 条件や依存がある可能性があります。

## コード上の追加ルール

- `shipment_groups`
  - 同じ `ebay_buyer_id` の注文だけを同梱グループに入れられる
  - 構成注文が 2 件未満になるとグループを削除する実装
  - `shipped` ステータスのグループは変更できない
- `inventory_counts`
  - `draft` のみ編集可能
  - `frozen` は入力ロック、`closed` は確定扱い
- `carrier_invoices`
  - import 監査用に `pending` / `imported` / `failed` / `skipped` を持つ
  - `updated_at` は trigger で自動更新

## 削除時に特に注意するテーブル

- `accounts`
  - account health、ケース、markdown、webhook など複数機能に波及します。
- `items`
  - traffic、price、openclaw に連鎖します。
- `carrier_invoices`
  - shipment、anomaly、unknown charge event が cascade します。
- `case_records`
  - event、item、memo が cascade します。
- `inventory_counts`
  - count lines が cascade します。
