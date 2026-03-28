# er-notes

ER 図やテーブル群の構造を補足するためのメモです。  
2026-03-25 時点の remote schema を元に、中心テーブルと孤立気味のテーブルを整理しています。

## 中心テーブル

- `users`
  - アプリ利用者の中心
  - `daily_memos`, `employees`, `fixed_costs`, `name_map`, `priority_quadrants` などに波及

- `accounts`
  - eBay アカウント単位の中心
  - `account_health_snapshots`, `case_records`, `markdown_presets`, `markdown_runs`, `webhooks` につながる

- `items`
  - 出品商品の中心
  - `openclaw_jobs`, `traffic_history`, `traffic_metrics`, `price_observations`, `price_recommendations`, `price_change_logs` につながる

- `orders`
  - 受注の中心
  - `case_records` と業務的に接続し、`order_line_items` は `order_no` で接続される

- `case_records`
  - ケース対応の中心
  - `case_events`, `case_items`, `case_memos` の親

- `carrier_invoices`
  - 配送請求の中心
  - `carrier_shipments`, `carrier_invoice_anomalies`, `carrier_unknown_charge_events` の親

- `manager_goals`
  - 目標管理ドメインの起点
  - `manager_kpis`, `manager_plans`, `manager_tasks` に接続する

## 孤立気味のテーブル

- `app_settings`
  - 外部キーはないが全体設定のため重要

- `audit_logs`
  - 監査用途で孤立しやすい

- `country_codes`
  - 辞書マスタで孤立していても問題ない

- `shipping_rates`
  - 外部キーが無くても料金表として独立している可能性が高い

- `shipco_senders`
  - 連携設定系のため独立しやすい

- `manager_task_schedules`
  - 予定管理としては独立度が高いが、`manager_tasks` に従属する

- `test`
  - 本当に孤立テーブルか、検証残骸かは要確認

## 構造上の注意

- `orders` と `order_line_items` は `id` ではなく `order_no` で結ばれている
- `inventory_locations` は `id` より `code` が参照キーとして使われる
- `octoparse_tasks` も `id` ではなく `task_id` が参照される
- `manager_tasks` は目標系と業務系の両方にぶら下がるハブになっている
- 外部キーが存在しない業務依存が残っている可能性が高い

## 今後の改善案

- `orders` 系の業務キーと surrogate key の使い分けを明文化する
- status 列挙値を別ドキュメントに分離する
- 履歴テーブルと現在値テーブルの区別を docs 上で明確化する
- `test` や役割不明テーブルの運用確認を行う
- 将来的に ER 図画像や Mermaid 図を保存する
