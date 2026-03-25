# tables

`public` schema のテーブル一覧です。  
初版は 2026-03-25 の remote schema pull を元に整理しています。用途欄にはカラム名から読み取れる内容も含むため、業務上の意味が異なる場合は必ず補正してください。

## 読み方

- 主キーは migration に定義されている内容を記載
- 主なカラムは把握用の抜粋であり全カラムではない
- 用途は AI と人間が全体像を掴むための要約
- 備考には docs のどこを追加で見るべきかを寄せる

## アカウント・ユーザー

| テーブル名 | 主キー | 主なカラム | 用途 | 備考 |
| --- | --- | --- | --- | --- |
| `users` | `id` | `email`, `username`, `password`, `usd_rate`, `eur_rate` | システム利用者の基礎情報と為替設定を保持 | 各種業務テーブルの親になっている |
| `accounts` | `id`, `user_id` | `ebay_user_id`, `access_token`, `refresh_token`, `spreadsheet_id` | eBay アカウント連携情報を保持 | 実質的には販売アカウントの中心 |
| `app_settings` | `key` | `key`, `value`, `updated_at` | アプリ全体の設定値を JSON で保持 | グローバル設定テーブル |
| `audit_logs` | `id` | `actor`, `action`, `entity_type`, `entity_id`, `details` | 監査ログを保持 | 業務データそのものではなく履歴用途 |
| `daily_memos` | `id` | `memo_date`, `content`, `user_id` | 日次メモや運用メモを保持 | `users` 参照あり |
| `priority_quadrants` | `id` | `title`, `detail`, `quadrant`, `status`, `due_date` | タスクや優先度整理用のメモ管理 | DB コア業務からはやや独立 |

## eBay 商品・受注・購入者

| テーブル名 | 主キー | 主なカラム | 用途 | 備考 |
| --- | --- | --- | --- | --- |
| `items` | `id` | `ebay_item_id`, `title`, `category_id`, `current_price_value`, `cost_price` | 出品商品マスタ | 価格変更、トラフィック、OpenClaw の基点 |
| `buyers` | `id` | `ebay_buyer_id`, `email`, `address`, `feedback_score`, `attention_flag` | 購入者情報を保持 | メッセージ・ケース・受注で参照 |
| `orders` | `id` | `order_no`, `buyer_id`, `shipping_status`, `cost_price`, `earnings`, `buyer_country_code` | 受注情報の中心テーブル | 送料・利益・発送・トラブル対応に波及。メッセージ送信状態も保持 |
| `order_line_items` | `id` | `order_no`, `legacy_item_id`, `procurement_site_name`, `line_item_cost_value` | 受注明細 | `orders.order_no` を参照する点に注意 |
| `order_history` | `id` | `order_id`, `buyer_id`, `status`, `order_date`, `total_amount` | 受注の履歴・スナップショット保持 | `orders` とは別用途の履歴テーブルに見える |
| `categories` | `id` | `category_id`, `category_name`, `category_level`, `category_path` | eBay カテゴリ情報の保持 | `items` の分類情報に対応 |
| `country_codes` | `code` | `name_ja`, `name_en`, `currency`, `ebay_currency` | 国コード辞書 | 配送・関税・購入者国判定の基礎 |
| `message_templates` | `id` | `template_name`, `body`, `image_url`, `user_id` | 購入者向けメッセージテンプレート | `message_history` から参照 |
| `message_history` | `id` | `ebay_buyer_id`, `template_id`, `message_type`, `body`, `sent_at` | 購入者への送信履歴 | `buyers.ebay_buyer_id` を参照 |

## ケース・CS 対応

| テーブル名 | 主キー | 主なカラム | 用途 | 備考 |
| --- | --- | --- | --- | --- |
| `case_records` | `id` | `ebay_case_id`, `account_id`, `buyer_id`, `order_id`, `case_type` | ケース管理の中心 | `case_type` は `RETURN` / `INR`、`status` と `resolution_due_at` が重要 |
| `case_items` | `id` | `case_id`, `order_line_item_id`, `title`, `quantity`, `refund_amount` | ケース対象の商品明細 | `order_line_items` と関連 |
| `case_events` | `id` | `case_id`, `event_type`, `occurred_at`, `payload` | ケースイベント履歴 | ケースの状態遷移ログ |
| `case_memos` | `id` | `case_id`, `author_user_id`, `body`, `created_at` | ケース内部メモ | 担当者メモ用途 |

## 価格調整・販売改善

| テーブル名 | 主キー | 主なカラム | 用途 | 備考 |
| --- | --- | --- | --- | --- |
| `traffic_history` | `id` | `item_id`, `ebay_item_id`, `listing_title`, `click_through_rate`, `category_name` | 出品ごとの過去トラフィック履歴 | 粒度は履歴スナップショット |
| `traffic_metrics` | `id` | `item_id`, `measured_at`, `impressions`, `page_views`, `quantity_sold` | 商品ごとの集計メトリクス | 価格推奨の元データ |
| `price_observations` | `id` | `item_id`, `observed_at`, `own_price`, `comp_min_price`, `comp_median_price` | 相場観測データ | 価格改定の判断材料 |
| `price_recommendations` | `id` | `item_id`, `metric_id`, `observation_id`, `action`, `confidence` | 価格改定提案 | AI またはロジックの推奨結果と見られる |
| `price_change_logs` | `id` | `item_id`, `recommendation_id`, `openclaw_job_id`, `old_price`, `new_price` | 実際の価格変更実績 | 失敗時レスポンスも保持 |
| `markdown_presets` | `id` | `account_id`, `title`, `discount_percent`, `price_min`, `price_max`, `category_ids` | Markdown セール実行条件のプリセット | アカウント単位 |
| `markdown_runs` | `id` | `account_id`, `preset_id`, `status`, `listing_count`, `executed_at` | Markdown セール実行履歴 | API request/response payload を保持 |
| `scoring_rules` | `id` | `version`, `weights`, `active` | スコアリングルール設定 | JSON/weights ベースのルール管理 |
| `ai_insights` | `id` | `date`, `input_metrics_json`, `output_insight_json`, `model`, `usage` | AI 分析結果の保存 | AI が参照する際の一次情報候補 |
| `account_health_snapshots` | `id` | `account_id`, `measured_at`, `seller_level`, `transaction_defect_rate`, `feedback_score` | アカウント健全性スナップショット | eBay アカウント評価の履歴 |

## 発送・配送・請求

| テーブル名 | 主キー | 主なカラム | 用途 | 備考 |
| --- | --- | --- | --- | --- |
| `shipment_groups` | `id` | `shipment_id`, `primary_order_no`, `tracking_number`, `shipping_carrier`, `status` | 複数注文を束ねた発送グループ | `status` は `draft` / `ready` / `shipped` |
| `shipment_group_orders` | `group_id`, `order_no` | `group_id`, `order_no`, `created_at` | 発送グループと注文の中間テーブル | 複合主キー |
| `shipping_rates` | `id` | `carrier`, `service_code`, `service_name`, `destination_scope`, `price_yen` | 送料マスタ | pricing 補助テーブル |
| `shipco_senders` | `id` | `company`, `full_name`, `country`, `city`, `email` | Ship&Co 差出人情報 | 発送ラベル連携用 |
| `carrier_invoices` | `id` | `carrier`, `invoice_number`, `invoice_date`, `billing_account`, `currency` | 運送会社請求書ヘッダ | `carrier_shipments` と `carrier_invoice_anomalies` の親 |
| `carrier_shipments` | `id` | `invoice_id`, `awb_number`, `shipment_date`, `tracking_number`, `carrier_actual_weight` | 運送会社の配送明細 | AWB 単位の請求・配送実績 |
| `carrier_charges` | `id` | `shipment_id`, `charge_code`, `charge_group`, `amount`, `invoice_category` | 運送会社請求明細 | `carrier_shipments` の子 |
| `carrier_invoice_anomalies` | `id` | `invoice_id`, `shipment_id`, `anomaly_code`, `details`, `fee_amount` | 請求異常・監査結果 | 請求精査テーブル |
| `carrier_charge_label_catalog` | `id` | `carrier`, `label_raw`, `normalized_label`, `default_group`, `is_known` | 請求ラベル正規化辞書 | 未知請求項目の正規化に使う |
| `carrier_unknown_charge_events` | `id` | `catalog_id`, `invoice_id`, `shipment_id`, `charge_name_raw`, `amount` | 未知請求ラベルの検出履歴 | カタログ整備の起点 |
| `carrier_invoice_import_logs` | `id` | `import_run_id`, `invoice_number`, `awb_number`, `charge_name_raw`, `message` | 請求データ取込ログ | 再取込時の調査用 |

## 在庫・棚卸・仕入れ補助

| テーブル名 | 主キー | 主なカラム | 用途 | 備考 |
| --- | --- | --- | --- | --- |
| `inventory_locations` | `id` | `code`, `name`, `created_at` | 在庫保管場所マスタ | `code` が他テーブルから参照される |
| `inventory_statuses` | `code` | `code`, `name` | 在庫状態マスタ | `inventory_units` が参照 |
| `inventory_units` | `id` | `item_id`, `location_code`, `status_code`, `cost_yen`, `condition_grade` | 個別在庫ユニット | 棚卸対象は `in_stock`, `returned`, `cancel_stock`, `domestic_sale` |
| `inventory_counts` | `id` | `location_code`, `status`, `title`, `counted_at`, `created_by` | 棚卸ヘッダ | `status` は `draft` / `frozen` / `closed` |
| `inventory_count_lines` | `id` | `inventory_count_id`, `sku`, `counted_qty`, `theoretical_qty`, `diff_qty` | 棚卸明細 | `inventory_counts` の子 |
| `inventory_management_schedules` | `id` | `task_id`, `days_of_week`, `time_of_day`, `enabled`, `task_delete_flg` | 在庫更新・棚卸系スケジュール | Octoparse タスク連携あり |
| `inventory_update_history` | `id` | `octoparse_task_id`, `ebay_user_id`, `success_count`, `failure_count`, `error_message` | 在庫更新実行履歴 | スクレイピング/更新バッチ寄り |
| `hts_codes` | `id` | `hts_code`, `category`, `duty_rate_percent`, `duty_amount_jpy` | 関税・HS コード辞書 | 発送/輸出計算補助 |

## 外部連携・ジョブ

| テーブル名 | 主キー | 主なカラム | 用途 | 備考 |
| --- | --- | --- | --- | --- |
| `octoparse_accounts` | `id` | `username`, `password`, `access_token`, `refresh_token`, `user_id` | Octoparse 連携アカウント | シークレットを含むため取扱注意 |
| `octoparse_tasks` | `id` | `task_id`, `task_name`, `ebay_user_id`, `user_id` | Octoparse タスク管理 | `inventory_management_schedules` から参照 |
| `openclaw_jobs` | `id` | `item_id`, `job_type`, `status`, `payload_json`, `result_json` | OpenClaw ジョブ管理 | 商品単位の外部ジョブ実行履歴 |
| `sheet_conversion_jobs` | `id` | `job_key`, `sheet_id`, `requested_by`, `processed_row_count`, `failed_row_count` | シート変換ジョブの親 | `sheet_conversion_job_items` の親 |
| `sheet_conversion_job_items` | `id` | `job_id`, `row_index`, `status`, `attempt_count`, `last_error` | シート変換ジョブの各行処理 | ジョブ粒度の詳細 |
| `webhooks` | `id` | `account_id`, `event_type`, `url`, `is_active` | アカウント別 Webhook 設定 | `accounts` に従属 |
| `system_errors` | `id` | `account_id`, `order_id`, `category`, `error_code`, `message` | システムエラー集約 | 注文やアカウントに紐づく障害記録 |

## 補助・個別用途

| テーブル名 | 主キー | 主なカラム | 用途 | 備考 |
| --- | --- | --- | --- | --- |
| `employees` | `id` | `display_name`, `bank_name`, `bank_code`, `account_number`, `user_id` | 社員・口座情報管理 | `name_map` の親 |
| `name_map` | `id` | `raw_name`, `employee_id`, `user_id`, `created_at` | 生テキスト名と社員の紐付け | 名寄せ用途 |
| `fixed_costs` | `id` | `name`, `category`, `amount_jpy`, `billing_cycle`, `active` | 固定費管理 | 利益計算補助の可能性 |
| `test` | `id`, `username` | `id`, `username`, `created_at` | テスト用の可能性が高いテーブル | 本番用途なら要確認 |

## 更新メモ

- 新テーブルを追加したら、少なくともこの一覧に 1 行追加する
- 主キーが複合キーのテーブルは必ず明記する
- 用途が曖昧な場合は「未確認」と書いて保留し、推測で断定しない
