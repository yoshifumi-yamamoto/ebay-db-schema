

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pgsodium";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pg_trgm" WITH SCHEMA "public";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE OR REPLACE FUNCTION "public"."get_existing_stocking_urls"("p_ebay_user_id" "text", "p_urls" "text"[]) RETURNS TABLE("stocking_url" "text")
    LANGUAGE "sql" STABLE
    AS $$
  select i.stocking_url
  from public.items i
  where i.ebay_user_id = p_ebay_user_id
    and i.listing_status = 'Active'
    and i.stocking_url = any(p_urls);
$$;


ALTER FUNCTION "public"."get_existing_stocking_urls"("p_ebay_user_id" "text", "p_urls" "text"[]) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."listings_summary_account_counts"("p_user_id" bigint, "p_start_date" "date", "p_end_date" "date") RETURNS TABLE("ebay_user_id" "text", "exhibit_count" bigint)
    LANGUAGE "sql" STABLE
    AS $$
select
  ebay_user_id,
  count(*) as exhibit_count
from items
where user_id = p_user_id
  and exhibit_date >= p_start_date
  and exhibit_date < (p_end_date + interval '1 day')
  and ebay_user_id is not null
  and ebay_user_id <> ''
group by ebay_user_id
order by ebay_user_id;
$$;


ALTER FUNCTION "public"."listings_summary_account_counts"("p_user_id" bigint, "p_start_date" "date", "p_end_date" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."listings_summary_counts"("p_user_id" bigint, "p_start_date" "date", "p_end_date" "date") RETURNS TABLE("researcher" "text", "exhibit_count" bigint, "research_count" bigint, "sales_count" bigint)
    LANGUAGE "sql" STABLE
    AS $$
with exhibit as (
  select
    exhibitor as name,
    count(*) as exhibit_count
  from items
  where user_id = p_user_id
    and exhibit_date >= p_start_date
    and exhibit_date < (p_end_date + interval '1 day')
  group by exhibitor
),
research as (
  select
    researcher as name,
    count(*) as research_count
  from items
  where user_id = p_user_id
    and research_date >= p_start_date
    and research_date < (p_end_date + interval '1 day')
  group by researcher
),
sales as (
  select
    researcher as name,
    count(*) as sales_count
  from orders
  where user_id = p_user_id
    and order_date >= p_start_date
    and order_date < (p_end_date + interval '1 day')
  group by researcher
),
names as (
  select name from exhibit
  union
  select name from research
  union
  select name from sales
)
select
  names.name as researcher,
  coalesce(exhibit.exhibit_count, 0) as exhibit_count,
  coalesce(research.research_count, 0) as research_count,
  coalesce(sales.sales_count, 0) as sales_count
from names
left join exhibit using (name)
left join research using (name)
left join sales using (name)
order by researcher nulls last;
$$;


ALTER FUNCTION "public"."listings_summary_counts"("p_user_id" bigint, "p_start_date" "date", "p_end_date" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."set_shipping_rates_updated_at"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  new.updated_at = now();
  return new;
end;
$$;


ALTER FUNCTION "public"."set_shipping_rates_updated_at"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."set_updated_at"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  new.updated_at = now();
  return new;
end;
$$;


ALTER FUNCTION "public"."set_updated_at"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."account_health_snapshots" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "account_id" bigint NOT NULL,
    "measured_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" bigint,
    "ebay_user_id" "text",
    "seller_level" "text",
    "projected_seller_level" "text",
    "account_status" "text",
    "registration_program" "text",
    "current_evaluation_date" timestamp with time zone,
    "projected_evaluation_date" timestamp with time zone,
    "current_evaluation_month" "text",
    "projected_evaluation_month" "text",
    "evaluation_reason" "text",
    "shipping_level" "text",
    "item_not_received_level" "text",
    "item_not_as_described_level" "text",
    "cases_closed_without_seller_resolution_count" numeric(12,4),
    "transaction_defect_rate" numeric(12,4),
    "peer_benchmark" "text",
    "feedback_score" integer,
    "positive_feedback_percent" numeric(8,4),
    "positive_feedback_count" integer,
    "neutral_feedback_count" integer,
    "negative_feedback_count" integer,
    "feedback_metrics" "jsonb",
    "selling_limit_count" integer,
    "selling_limit_amount" numeric(12,2),
    "selling_limit_currency" "text",
    "standards_current_raw" "jsonb",
    "standards_projected_raw" "jsonb",
    "privileges_raw" "jsonb",
    "feedback_summary_raw" "jsonb",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."account_health_snapshots" OWNER TO "postgres";


COMMENT ON TABLE "public"."account_health_snapshots" IS 'eBay account health snapshots keyed by baywork accounts.id. Stores seller standards, feedback summary, and selling limit history.';



COMMENT ON COLUMN "public"."account_health_snapshots"."account_id" IS 'FK to accounts.id. accounts remains the source of truth for account master data and tokens.';



COMMENT ON COLUMN "public"."account_health_snapshots"."feedback_metrics" IS 'Normalized feedback metric array from eBay Feedback API for flexible MCP-side rendering.';



COMMENT ON COLUMN "public"."account_health_snapshots"."standards_current_raw" IS 'Raw payload from Analytics API getSellerStandardsProfile CURRENT.';



COMMENT ON COLUMN "public"."account_health_snapshots"."standards_projected_raw" IS 'Raw payload from Analytics API getSellerStandardsProfile PROJECTED.';



COMMENT ON COLUMN "public"."account_health_snapshots"."privileges_raw" IS 'Raw payload from Account API getPrivileges.';



COMMENT ON COLUMN "public"."account_health_snapshots"."feedback_summary_raw" IS 'Raw payload from Feedback API getFeedbackRatingSummary.';



CREATE TABLE IF NOT EXISTS "public"."accounts" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" bigint NOT NULL,
    "access_token" "text",
    "ebay_user_id" character varying,
    "token_expiration" "text",
    "refresh_token" "text",
    "spreadsheet_id" "text",
    "stock_satus_csv_upload_drive_id" "text",
    "theme_color" "text"
);


ALTER TABLE "public"."accounts" OWNER TO "postgres";


ALTER TABLE "public"."accounts" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."accounts_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."ai_insights" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" bigint NOT NULL,
    "date" "text" NOT NULL,
    "input_metrics_json" "jsonb" NOT NULL,
    "output_insight_json" "jsonb",
    "model" "text",
    "usage" "jsonb",
    "error_message" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."ai_insights" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."app_settings" (
    "key" "text" NOT NULL,
    "value" "jsonb" NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."app_settings" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."audit_logs" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "entity_type" "text" NOT NULL,
    "entity_id" "uuid",
    "action" "text" NOT NULL,
    "actor" "text" NOT NULL,
    "details" "jsonb",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."audit_logs" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."items" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "title" "text",
    "ebay_user_id" "text",
    "stocking_url" "text",
    "cost_price" bigint,
    "ebay_item_id" "text",
    "estimated_shipping_cost" bigint,
    "researcher" "text",
    "exhibitor" "text",
    "research_date" "date",
    "exhibit_date" "date",
    "stock_status" "text",
    "last_update" timestamp with time zone,
    "user_id" bigint,
    "item_status" character varying(50),
    "quantity" bigint,
    "last_synced_at" timestamp without time zone,
    "updated_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "category_id" character varying(255),
    "category_name" character varying(255),
    "category_level" integer,
    "best_offer_enabled" boolean,
    "category_path" character varying,
    "selling_state" character varying(50),
    "listing_status" character varying(50),
    "status_synced_at" timestamp without time zone,
    "item_title" "text",
    "current_price_value" numeric,
    "current_price_currency" "text",
    "primary_image_url" "text",
    "view_item_url" "text",
    "estimated_parcel_length" numeric,
    "estimated_parcel_width" numeric,
    "estimated_parcel_height" numeric,
    "estimated_parcel_weight" numeric,
    "sku" "text",
    "marketplace_id" "text"
);


ALTER TABLE "public"."items" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."baypilot_items" AS
 SELECT "items"."id",
    "items"."sku",
    "items"."ebay_item_id",
    "items"."ebay_user_id",
    COALESCE("items"."title", "items"."item_title", "items"."ebay_item_id") AS "title",
    "items"."category_name" AS "category",
    NULL::"text" AS "condition",
    (COALESCE("items"."current_price_value", (0)::numeric))::numeric(12,2) AS "current_price",
    COALESCE("items"."current_price_currency", 'USD'::"text") AS "currency",
    COALESCE("items"."item_status", "items"."listing_status", 'active'::character varying) AS "status",
    NULL::integer AS "handling_time",
    NULL::timestamp with time zone AS "last_price_changed_at",
    COALESCE("items"."created_at", ("items"."updated_at")::timestamp with time zone, "now"()) AS "created_at",
    COALESCE(("items"."updated_at")::timestamp with time zone, "now"()) AS "updated_at"
   FROM "public"."items";


ALTER TABLE "public"."baypilot_items" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."buyers" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" bigint,
    "ebay_user_id" character varying,
    "name" character varying,
    "email" character varying,
    "feedback_score" bigint,
    "phone_number" character varying,
    "address" "jsonb",
    "ebay_buyer_id" character varying,
    "registered_date" timestamp with time zone,
    "last_purchase_date" timestamp without time zone,
    "last_message_date" timestamp without time zone,
    "last_message_id" integer,
    "last_template_id" integer,
    "last_template_name" character varying(255),
    "attention_flag" boolean DEFAULT false
);


ALTER TABLE "public"."buyers" OWNER TO "postgres";


ALTER TABLE "public"."buyers" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."buyers_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."carrier_charge_label_catalog" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "carrier" "text" NOT NULL,
    "label_raw" "text" NOT NULL,
    "normalized_label" "text" NOT NULL,
    "default_group" "text" NOT NULL,
    "is_known" boolean DEFAULT true NOT NULL,
    "is_active" boolean DEFAULT true NOT NULL,
    "note" "text",
    "updated_by" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "carrier_charge_label_catalog_default_group_check" CHECK (("default_group" = ANY (ARRAY['shipping'::"text", 'customs'::"text", 'fee'::"text", 'fee_tax'::"text", 'other'::"text", 'ignore'::"text"])))
);


ALTER TABLE "public"."carrier_charge_label_catalog" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."carrier_charges" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "shipment_id" "uuid" NOT NULL,
    "charge_group" "text" NOT NULL,
    "charge_name_raw" "text" NOT NULL,
    "amount" numeric NOT NULL,
    "charge_code" "text",
    "invoice_category" "text",
    "line_no" integer,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "header_occurrence_no" integer,
    CONSTRAINT "carrier_charges_charge_group_check" CHECK (("charge_group" = ANY (ARRAY['shipping'::"text", 'customs'::"text", 'fee'::"text", 'fee_tax'::"text", 'other'::"text"])))
);


ALTER TABLE "public"."carrier_charges" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."carrier_invoice_anomalies" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "shipment_id" "uuid" NOT NULL,
    "invoice_id" "uuid",
    "carrier" "text" NOT NULL,
    "invoice_number" "text",
    "awb_number" "text" NOT NULL,
    "order_id" bigint,
    "order_no" "text",
    "ebay_user_id" "text",
    "buyer_country_code" "text",
    "anomaly_code" "text" NOT NULL,
    "severity" "text" NOT NULL,
    "message" "text" NOT NULL,
    "shipping_amount" numeric,
    "customs_amount" numeric,
    "fee_amount" numeric,
    "total_amount" numeric,
    "details" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "resolved" boolean DEFAULT false NOT NULL,
    "resolved_at" timestamp with time zone,
    "first_detected_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "last_detected_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "fee_tax_amount" numeric,
    "fee_amount_incl_tax" numeric,
    "resolved_reason" "text",
    "resolved_by" "text",
    "resolved_note" "text",
    CONSTRAINT "carrier_invoice_anomalies_severity_check" CHECK (("severity" = ANY (ARRAY['low'::"text", 'medium'::"text", 'high'::"text", 'warning'::"text"])))
);


ALTER TABLE "public"."carrier_invoice_anomalies" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."carrier_invoice_import_logs" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "carrier" "text" NOT NULL,
    "source_file_name" "text" NOT NULL,
    "import_run_id" "uuid" NOT NULL,
    "invoice_number" "text",
    "row_no" integer,
    "awb_number" "text",
    "header_occurrence_no" integer,
    "charge_name_raw" "text",
    "raw_amount" "text",
    "severity" "text" NOT NULL,
    "message" "text" NOT NULL,
    "context" "jsonb",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "carrier_invoice_import_logs_carrier_check" CHECK (("carrier" = ANY (ARRAY['DHL'::"text", 'FEDEX'::"text"]))),
    CONSTRAINT "carrier_invoice_import_logs_severity_check" CHECK (("severity" = ANY (ARRAY['error'::"text", 'warning'::"text", 'info'::"text"])))
);


ALTER TABLE "public"."carrier_invoice_import_logs" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."carrier_invoices" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "carrier" "text" NOT NULL,
    "invoice_number" "text" NOT NULL,
    "invoice_date" "date",
    "currency" "text",
    "billing_account" "text",
    "source_file_name" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "carrier_invoices_carrier_check" CHECK (("carrier" = ANY (ARRAY['DHL'::"text", 'FEDEX'::"text"])))
);


ALTER TABLE "public"."carrier_invoices" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."carrier_shipments" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "invoice_id" "uuid" NOT NULL,
    "awb_number" "text" NOT NULL,
    "shipment_date" "date",
    "reference_1" "text",
    "shipment_total" numeric,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "carrier_actual_weight" numeric,
    "carrier_actual_weight_unit" "text",
    "carrier_billed_weight" numeric,
    "carrier_billed_weight_unit" "text",
    "carrier_dim_length" numeric,
    "carrier_dim_width" numeric,
    "carrier_dim_height" numeric,
    "carrier_dim_unit" "text",
    "carrier_weight_flag" "text",
    "carrier_dimensions_raw" "text"
);


ALTER TABLE "public"."carrier_shipments" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."carrier_unknown_charge_events" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "shipment_id" "uuid" NOT NULL,
    "invoice_id" "uuid",
    "carrier" "text" NOT NULL,
    "invoice_number" "text",
    "awb_number" "text" NOT NULL,
    "charge_name_raw" "text" NOT NULL,
    "normalized_label" "text" NOT NULL,
    "amount" numeric NOT NULL,
    "header_occurrence_no" integer,
    "line_no" integer,
    "resolved" boolean DEFAULT false NOT NULL,
    "resolved_at" timestamp with time zone,
    "catalog_id" "uuid",
    "first_detected_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "last_detected_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."carrier_unknown_charge_events" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."case_events" (
    "id" bigint NOT NULL,
    "case_id" bigint NOT NULL,
    "event_type" "text" NOT NULL,
    "payload" "jsonb",
    "occurred_at" timestamp with time zone DEFAULT "now"(),
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."case_events" OWNER TO "postgres";


ALTER TABLE "public"."case_events" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."case_events_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."case_items" (
    "id" bigint NOT NULL,
    "case_id" bigint NOT NULL,
    "order_line_item_id" "text",
    "title" "text",
    "quantity" integer,
    "refund_amount" numeric(12,2),
    "currency_code" "text"
);


ALTER TABLE "public"."case_items" OWNER TO "postgres";


ALTER TABLE "public"."case_items" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."case_items_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."case_memos" (
    "id" bigint NOT NULL,
    "case_id" bigint NOT NULL,
    "author_user_id" bigint,
    "body" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."case_memos" OWNER TO "postgres";


ALTER TABLE "public"."case_memos" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."case_memos_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."case_records" (
    "id" bigint NOT NULL,
    "ebay_case_id" "text",
    "case_type" "text" NOT NULL,
    "status" "text" NOT NULL,
    "account_id" bigint NOT NULL,
    "order_id" bigint,
    "buyer_id" bigint,
    "assignee_user_id" bigint,
    "reason" "text",
    "requested_action" "text",
    "expected_refund" numeric(12,2),
    "currency_code" "text",
    "memo" "text",
    "opened_at" timestamp with time zone DEFAULT "now"(),
    "resolution_due_at" timestamp with time zone,
    "last_responded_at" timestamp with time zone,
    "return_tracking_number" "text",
    "return_carrier" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "case_records_case_type_check" CHECK (("case_type" = ANY (ARRAY['RETURN'::"text", 'INR'::"text"])))
);


ALTER TABLE "public"."case_records" OWNER TO "postgres";


ALTER TABLE "public"."case_records" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."case_records_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."categories" (
    "id" bigint NOT NULL,
    "category_id" "text" NOT NULL,
    "category_name" "text",
    "parent_category_id" "text",
    "category_level" integer,
    "category_path" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."categories" OWNER TO "postgres";


ALTER TABLE "public"."categories" ALTER COLUMN "id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME "public"."categories_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."country_codes" (
    "code" "text" NOT NULL,
    "name_ja" "text" NOT NULL,
    "name_en" "text" NOT NULL,
    "currency" "text",
    "ebay_currency" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."country_codes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."daily_memos" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" integer NOT NULL,
    "memo_date" "date" NOT NULL,
    "content" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."daily_memos" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."employees" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" integer NOT NULL,
    "display_name" "text" NOT NULL,
    "payroll_name" "text" NOT NULL,
    "status" "text" DEFAULT 'active'::"text" NOT NULL,
    "incentive_rate" numeric(5,4) DEFAULT 0.10 NOT NULL,
    "bank_code" "text",
    "bank_name" "text",
    "branch_code" "text",
    "branch_name" "text",
    "account_type" "text",
    "account_number" "text",
    "account_name" "text",
    "account_name_kana" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "employees_status_check" CHECK (("status" = ANY (ARRAY['active'::"text", 'inactive'::"text"])))
);


ALTER TABLE "public"."employees" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."fixed_costs" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" integer NOT NULL,
    "name" "text" NOT NULL,
    "amount_jpy" numeric DEFAULT 0 NOT NULL,
    "category" "text",
    "billing_cycle" "text" DEFAULT 'monthly'::"text" NOT NULL,
    "start_date" "date",
    "end_date" "date",
    "note" "text",
    "active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."fixed_costs" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."hts_codes" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" bigint NOT NULL,
    "hts_code" "text" NOT NULL,
    "category" "text",
    "duty_rate_percent" numeric,
    "duty_amount_jpy" numeric,
    "note" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."hts_codes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."inventory_count_lines" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "inventory_count_id" "uuid" NOT NULL,
    "sku" "text" NOT NULL,
    "theoretical_qty" integer DEFAULT 0 NOT NULL,
    "counted_qty" integer,
    "diff_qty" integer GENERATED ALWAYS AS (
CASE
    WHEN ("counted_qty" IS NULL) THEN NULL::integer
    ELSE ("counted_qty" - "theoretical_qty")
END) STORED,
    "unit_cost_yen" integer,
    "diff_value_yen" integer GENERATED ALWAYS AS (
CASE
    WHEN (("counted_qty" IS NULL) OR ("unit_cost_yen" IS NULL)) THEN NULL::integer
    ELSE (("counted_qty" - "theoretical_qty") * "unit_cost_yen")
END) STORED,
    "note" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."inventory_count_lines" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."inventory_counts" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" bigint NOT NULL,
    "title" "text" NOT NULL,
    "counted_at" "date" NOT NULL,
    "location_code" "text" NOT NULL,
    "status" "text" DEFAULT 'draft'::"text" NOT NULL,
    "created_by" bigint,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "inventory_counts_status_check" CHECK (("status" = ANY (ARRAY['draft'::"text", 'frozen'::"text", 'closed'::"text"])))
);


ALTER TABLE "public"."inventory_counts" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."inventory_locations" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "code" "text" NOT NULL,
    "name" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."inventory_locations" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."inventory_management_schedules" (
    "id" integer NOT NULL,
    "user_id" integer NOT NULL,
    "time_of_day" time without time zone NOT NULL,
    "enabled" boolean DEFAULT true,
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp without time zone DEFAULT "now"(),
    "days_of_week" integer[],
    "task_id" "uuid",
    "task_delete_flg" boolean DEFAULT false
);


ALTER TABLE "public"."inventory_management_schedules" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."inventory_management_schedules_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."inventory_management_schedules_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."inventory_management_schedules_id_seq" OWNED BY "public"."inventory_management_schedules"."id";



CREATE TABLE IF NOT EXISTS "public"."inventory_statuses" (
    "code" "text" NOT NULL,
    "name" "text" NOT NULL
);


ALTER TABLE "public"."inventory_statuses" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."inventory_units" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" bigint NOT NULL,
    "sku" "text" NOT NULL,
    "item_id" bigint,
    "location_code" "text" NOT NULL,
    "status_code" "text" NOT NULL,
    "cost_yen" integer,
    "condition_grade" "text",
    "note" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "procurement_url" "text",
    "procurement_source" "text",
    "researcher" "text"
);


ALTER TABLE "public"."inventory_units" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."inventory_update_history" (
    "id" integer NOT NULL,
    "update_time" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "user_id" integer NOT NULL,
    "log_file_id" "text",
    "success_count" bigint,
    "failure_count" bigint,
    "octoparse_task_id" "text",
    "ebay_user_id" "text",
    "error_message" "text",
    "task_delete_status" boolean DEFAULT false
);


ALTER TABLE "public"."inventory_update_history" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."inventory_update_history_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."inventory_update_history_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."inventory_update_history_id_seq" OWNED BY "public"."inventory_update_history"."id";



ALTER TABLE "public"."items" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."items_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."markdown_presets" (
    "id" bigint NOT NULL,
    "account_id" bigint NOT NULL,
    "title" "text" NOT NULL,
    "discount_percent" numeric(5,2) NOT NULL,
    "category_ids" "jsonb" DEFAULT '[]'::"jsonb" NOT NULL,
    "price_min" numeric(12,2),
    "price_max" numeric(12,2),
    "description" "text",
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "markdown_presets_discount_percent_check" CHECK ((("discount_percent" > (0)::numeric) AND ("discount_percent" < (100)::numeric))),
    CONSTRAINT "markdown_presets_price_range_chk" CHECK ((("price_min" IS NULL) OR ("price_max" IS NULL) OR ("price_min" <= "price_max")))
);


ALTER TABLE "public"."markdown_presets" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."markdown_presets_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."markdown_presets_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."markdown_presets_id_seq" OWNED BY "public"."markdown_presets"."id";



CREATE TABLE IF NOT EXISTS "public"."markdown_runs" (
    "id" bigint NOT NULL,
    "preset_id" bigint,
    "account_id" bigint NOT NULL,
    "status" "text" NOT NULL,
    "promotion_id" "text",
    "listing_count" integer DEFAULT 0 NOT NULL,
    "request_payload" "jsonb",
    "response_payload" "jsonb",
    "error_message" "text",
    "executed_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."markdown_runs" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."markdown_runs_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."markdown_runs_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."markdown_runs_id_seq" OWNED BY "public"."markdown_runs"."id";



CREATE TABLE IF NOT EXISTS "public"."message_history" (
    "id" bigint NOT NULL,
    "ebay_buyer_id" "text" NOT NULL,
    "user_id" bigint NOT NULL,
    "template_id" bigint,
    "body" "text" NOT NULL,
    "sent_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "message_type" character varying NOT NULL
);


ALTER TABLE "public"."message_history" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."message_templates" (
    "id" bigint NOT NULL,
    "user_id" bigint NOT NULL,
    "template_name" character varying NOT NULL,
    "body" "text" NOT NULL,
    "image_url" character varying,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."message_templates" OWNER TO "postgres";


ALTER TABLE "public"."message_templates" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."message_templates_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



ALTER TABLE "public"."message_history" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."messages_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."name_map" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" integer NOT NULL,
    "raw_name" "text" NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."name_map" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."octoparse_accounts" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" bigint,
    "access_token" "text",
    "expires_in" bigint,
    "refresh_token" "text",
    "access_token_updated_at" timestamp without time zone,
    "refresh_token_updated_at" timestamp without time zone,
    "username" "text",
    "password" "text"
);


ALTER TABLE "public"."octoparse_accounts" OWNER TO "postgres";


ALTER TABLE "public"."octoparse_accounts" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."octoparse_accounts_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."octoparse_tasks" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "task_id" "uuid",
    "user_id" bigint NOT NULL,
    "task_name" "text",
    "ebay_user_id" "text",
    "updated_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL
);


ALTER TABLE "public"."octoparse_tasks" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."openclaw_jobs" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "job_type" "text" NOT NULL,
    "item_id" bigint NOT NULL,
    "payload_json" "jsonb" NOT NULL,
    "status" "text" DEFAULT 'queued'::"text" NOT NULL,
    "result_json" "jsonb",
    "error_message" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "started_at" timestamp with time zone,
    "completed_at" timestamp with time zone,
    CONSTRAINT "openclaw_jobs_job_type_check" CHECK (("job_type" = ANY (ARRAY['traffic_capture'::"text", 'market_research'::"text", 'apply_price_change'::"text"]))),
    CONSTRAINT "openclaw_jobs_status_check" CHECK (("status" = ANY (ARRAY['queued'::"text", 'running'::"text", 'completed'::"text", 'failed'::"text"])))
);


ALTER TABLE "public"."openclaw_jobs" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."order_history" (
    "id" bigint NOT NULL,
    "buyer_id" bigint NOT NULL,
    "user_id" bigint NOT NULL,
    "ebay_user_id" character varying NOT NULL,
    "ebay_buyer_id" character varying NOT NULL,
    "order_id" character varying NOT NULL,
    "order_date" timestamp with time zone NOT NULL,
    "total_amount" numeric NOT NULL,
    "currency" character varying NOT NULL,
    "status" character varying NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."order_history" OWNER TO "postgres";


ALTER TABLE "public"."order_history" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."order_history_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."orders" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "ebay_buyer_id" character varying,
    "ebay_user_id" "text",
    "order_date" timestamp without time zone,
    "order_no" character varying,
    "total_amount" real,
    "status" character varying,
    "ship_to" "jsonb",
    "buyer_id" bigint,
    "stocking_status" "text" DEFAULT 'NEW'::"text",
    "purchase_msg_status" "text" DEFAULT 'UNSEND'::"text",
    "shipping_status" "text" DEFAULT 'UNSHIPPED'::"text",
    "shipping_deadline" timestamp with time zone,
    "shipped_msg_status" "text" DEFAULT 'UNSEND'::"text",
    "delivered_msg_status" "text" DEFAULT 'UNSEND'::"text",
    "stocking_url" "text",
    "supplier_link" "text",
    "line_items" "jsonb",
    "user_id" bigint,
    "estimated_shipping_cost" bigint,
    "cost_price" bigint,
    "ebay_shipment_status" "text",
    "image_url" "text",
    "earnings" real,
    "subtotal" real,
    "earnings_after_pl_fee" real,
    "buyer_country_code" "text",
    "note" "text",
    "researcher" "text",
    "shipping_tracking_number" "text",
    "shipco_synced_at" timestamp with time zone,
    "total_amount_currency" "text",
    "subtotal_currency" "text",
    "earnings_currency" "text",
    "earnings_after_pl_fee_currency" "text",
    "confirming" boolean DEFAULT false NOT NULL,
    "damaged" boolean DEFAULT false NOT NULL,
    "shipco_parcel_weight" numeric,
    "shipco_parcel_weight_unit" "text",
    "shipco_parcel_length" numeric,
    "shipco_parcel_width" numeric,
    "shipco_parcel_height" numeric,
    "shipco_parcel_dimension_unit" "text",
    "shipping_carrier" "text",
    "final_shipping_cost" numeric,
    "bundle_excluded" boolean DEFAULT false NOT NULL,
    "shipco_shipping_cost" numeric,
    "estimated_parcel_length" numeric,
    "estimated_parcel_width" numeric,
    "estimated_parcel_height" numeric,
    "estimated_parcel_weight" numeric,
    "notion_url" "text",
    "shipping_reconciled_at" timestamp with time zone,
    "duty_reconciled_at" timestamp with time zone,
    "shipment_recorded_at" timestamp with time zone
);


ALTER TABLE "public"."orders" OWNER TO "postgres";


COMMENT ON COLUMN "public"."orders"."earnings" IS '支払い総額から手数料等を引いた額';



ALTER TABLE "public"."orders" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."order_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."order_line_items" (
    "id" "text" NOT NULL,
    "order_no" "text" NOT NULL,
    "legacy_item_id" "text",
    "title" "text",
    "quantity" integer,
    "total_value" numeric,
    "total_currency" "text",
    "line_item_cost_value" numeric,
    "line_item_cost_currency" "text",
    "cost_price" numeric,
    "item_image" "text",
    "stocking_url" "text",
    "researcher" "text",
    "procurement_url" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "procurement_tracking_number" "text",
    "procurement_status" "text" DEFAULT 'NEW'::"text",
    "procurement_ordered_at" timestamp with time zone,
    "procurement_site_name" "text"
);


ALTER TABLE "public"."order_line_items" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."price_change_logs" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "item_id" bigint NOT NULL,
    "recommendation_id" "uuid",
    "openclaw_job_id" "uuid",
    "changed_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "old_price" numeric(12,2) NOT NULL,
    "new_price" numeric(12,2) NOT NULL,
    "execution_type" "text" NOT NULL,
    "executed_by" "text",
    "result" "text" NOT NULL,
    "error_message" "text",
    "raw_response" "jsonb",
    CONSTRAINT "price_change_logs_execution_type_check" CHECK (("execution_type" = ANY (ARRAY['manual'::"text", 'openclaw'::"text"]))),
    CONSTRAINT "price_change_logs_result_check" CHECK (("result" = ANY (ARRAY['success'::"text", 'failed'::"text"])))
);


ALTER TABLE "public"."price_change_logs" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."price_observations" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "item_id" bigint NOT NULL,
    "observed_at" timestamp with time zone NOT NULL,
    "own_price" numeric(12,2) NOT NULL,
    "comp_min_price" numeric(12,2),
    "comp_median_price" numeric(12,2),
    "sold_min_price" numeric(12,2),
    "sold_median_price" numeric(12,2),
    "sold_count_30d" integer,
    "shipping_notes" "text",
    "condition_notes" "text",
    "raw_summary" "jsonb",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."price_observations" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."price_recommendations" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "item_id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "current_price" numeric(12,2) NOT NULL,
    "recommended_price" numeric(12,2) NOT NULL,
    "action" "text" NOT NULL,
    "reason" "text" NOT NULL,
    "confidence" numeric(5,2) NOT NULL,
    "status" "text" DEFAULT 'pending'::"text" NOT NULL,
    "rule_version" "text" NOT NULL,
    "observation_id" "uuid",
    "metric_id" "uuid",
    "approved_at" timestamp with time zone,
    "approved_by" "text",
    "rejected_at" timestamp with time zone,
    "rejected_by" "text",
    CONSTRAINT "price_recommendations_action_check" CHECK (("action" = ANY (ARRAY['raise'::"text", 'lower'::"text", 'keep'::"text", 'review'::"text"]))),
    CONSTRAINT "price_recommendations_status_check" CHECK (("status" = ANY (ARRAY['pending'::"text", 'approved'::"text", 'rejected'::"text", 'applied'::"text", 'failed'::"text"])))
);


ALTER TABLE "public"."price_recommendations" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."priority_quadrants" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" integer NOT NULL,
    "title" "text" NOT NULL,
    "detail" "text",
    "quadrant" "text" NOT NULL,
    "due_date" "date",
    "is_done" boolean DEFAULT false NOT NULL,
    "order_index" integer DEFAULT 0 NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "status" "text" DEFAULT 'NEW'::"text" NOT NULL,
    CONSTRAINT "priority_quadrants_quadrant_check" CHECK (("quadrant" = ANY (ARRAY['IU'::"text", 'IN'::"text", 'NU'::"text", 'NN'::"text"]))),
    CONSTRAINT "priority_quadrants_status_check" CHECK (("status" = ANY (ARRAY['NEW'::"text", 'IN_PROGRESS'::"text", 'DONE'::"text"])))
);


ALTER TABLE "public"."priority_quadrants" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."scoring_rules" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "version" "text" NOT NULL,
    "weights" "jsonb" NOT NULL,
    "active" boolean DEFAULT false NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."scoring_rules" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."sheet_conversion_job_items" (
    "id" bigint NOT NULL,
    "job_id" "uuid" NOT NULL,
    "row_index" integer NOT NULL,
    "source_title" "text",
    "status" "text" DEFAULT 'pending'::"text" NOT NULL,
    "step" "text" DEFAULT 'pending'::"text" NOT NULL,
    "attempt_count" integer DEFAULT 0 NOT NULL,
    "backend_endpoint" "text",
    "started_at" timestamp with time zone,
    "finished_at" timestamp with time zone,
    "duration_ms" integer,
    "last_error" "jsonb",
    "output_payload" "jsonb",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "sheet_conversion_job_items_status_check" CHECK (("status" = ANY (ARRAY['pending'::"text", 'running'::"text", 'succeeded'::"text", 'failed'::"text", 'skipped'::"text"]))),
    CONSTRAINT "sheet_conversion_job_items_step_check" CHECK (("step" = ANY (ARRAY['pending'::"text", 'gpt_request'::"text", 'image_shorten'::"text", 'mapping'::"text", 'done'::"text", 'failed'::"text"])))
);


ALTER TABLE "public"."sheet_conversion_job_items" OWNER TO "postgres";


ALTER TABLE "public"."sheet_conversion_job_items" ALTER COLUMN "id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME "public"."sheet_conversion_job_items_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."sheet_conversion_jobs" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "job_key" "text" NOT NULL,
    "requested_by" "text",
    "sheet_id" "text" NOT NULL,
    "source_row_count" integer DEFAULT 0 NOT NULL,
    "processed_row_count" integer DEFAULT 0 NOT NULL,
    "succeeded_row_count" integer DEFAULT 0 NOT NULL,
    "failed_row_count" integer DEFAULT 0 NOT NULL,
    "status" "text" DEFAULT 'queued'::"text" NOT NULL,
    "stop_reason" "text",
    "settings" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "summary" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "last_error" "jsonb",
    "started_at" timestamp with time zone,
    "completed_at" timestamp with time zone,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "sheet_conversion_jobs_status_check" CHECK (("status" = ANY (ARRAY['queued'::"text", 'running'::"text", 'completed'::"text", 'failed'::"text", 'canceled'::"text", 'completed_with_errors'::"text"])))
);


ALTER TABLE "public"."sheet_conversion_jobs" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."sheet_conversion_job_progress" AS
 SELECT "j"."id",
    "j"."job_key",
    "j"."sheet_id",
    "j"."status",
    "j"."source_row_count",
    "j"."processed_row_count",
    "j"."succeeded_row_count",
    "j"."failed_row_count",
        CASE
            WHEN ("j"."source_row_count" <= 0) THEN (0)::numeric
            ELSE "round"(((("j"."processed_row_count")::numeric / ("j"."source_row_count")::numeric) * (100)::numeric), 1)
        END AS "progress_percent",
    "j"."started_at",
    "j"."completed_at",
    "j"."created_at",
    "j"."updated_at"
   FROM "public"."sheet_conversion_jobs" "j";


ALTER TABLE "public"."sheet_conversion_job_progress" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."shipco_senders" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" bigint NOT NULL,
    "full_name" "text",
    "phone" "text",
    "email" "text",
    "company" "text",
    "country" "text",
    "zip" "text",
    "province" "text",
    "city" "text",
    "address1" "text",
    "address2" "text",
    "address3" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."shipco_senders" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."shipment_group_orders" (
    "group_id" "uuid" NOT NULL,
    "order_no" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."shipment_group_orders" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."shipment_groups" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" bigint NOT NULL,
    "status" "text" DEFAULT 'draft'::"text" NOT NULL,
    "primary_order_no" "text",
    "tracking_number" "text",
    "shipping_carrier" "text",
    "shipped_at" timestamp with time zone,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "label_url" "text",
    "shipment_id" "text",
    CONSTRAINT "shipment_groups_status_check" CHECK (("status" = ANY (ARRAY['draft'::"text", 'ready'::"text", 'shipped'::"text"])))
);


ALTER TABLE "public"."shipment_groups" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."shipping_rates" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "carrier" "text" NOT NULL,
    "service_code" "text" NOT NULL,
    "service_name" "text",
    "destination_scope" "text" NOT NULL,
    "zone" integer,
    "weight_max_g" integer NOT NULL,
    "price_yen" integer NOT NULL,
    "source" "text" DEFAULT 'manual'::"text" NOT NULL,
    "last_synced_at" timestamp with time zone,
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "shipping_rates_carrier_check" CHECK (("carrier" = ANY (ARRAY['JP_POST'::"text", 'FEDEX'::"text", 'DHL'::"text"]))),
    CONSTRAINT "shipping_rates_destination_scope_check" CHECK (("destination_scope" = ANY (ARRAY['US'::"text", 'GB'::"text", 'SG'::"text", 'ZONE'::"text"]))),
    CONSTRAINT "shipping_rates_price_yen_check" CHECK (("price_yen" >= 0)),
    CONSTRAINT "shipping_rates_weight_max_g_check" CHECK (("weight_max_g" > 0)),
    CONSTRAINT "shipping_rates_zone_check" CHECK ((("zone" IS NULL) OR (("zone" >= 1) AND ("zone" <= 5))))
);


ALTER TABLE "public"."shipping_rates" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."system_errors" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "error_code" "text" NOT NULL,
    "category" "text" NOT NULL,
    "severity" "text" NOT NULL,
    "provider" "text" NOT NULL,
    "message" "text" NOT NULL,
    "retryable" boolean DEFAULT false NOT NULL,
    "user_id" bigint,
    "account_id" bigint,
    "order_id" bigint,
    "job_id" "uuid",
    "request_id" "text",
    "payload_summary" "jsonb",
    "details" "jsonb"
);


ALTER TABLE "public"."system_errors" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."system_errors_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."system_errors_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."system_errors_id_seq" OWNED BY "public"."system_errors"."id";



CREATE TABLE IF NOT EXISTS "public"."test" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "username" "text" NOT NULL
);


ALTER TABLE "public"."test" OWNER TO "postgres";


ALTER TABLE "public"."test" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."test_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."traffic_history" (
    "id" bigint NOT NULL,
    "item_id" bigint,
    "ebay_item_id" "text",
    "report_month" character varying(7),
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "user_id" integer,
    "ebay_user_id" character varying(255),
    "category_id" character varying(255),
    "category_name" character varying(255),
    "listing_title" character varying(255),
    "current_promoted_listings_status" character varying(255),
    "quantity_available" integer,
    "total_impressions_on_ebay_site" integer,
    "click_through_rate" numeric(5,2),
    "quantity_sold" integer,
    "sales_conversion_rate" numeric(5,2),
    "top_20_search_spot_impressions_from_promoted_listings" integer,
    "percent_change_in_top_20_search_spot_impressions_from_promoted_" numeric(5,2),
    "top_20_search_spot_organic_impressions" integer,
    "percent_change_in_top_20_search_spot_organic_impressions" numeric(5,2),
    "rest_of_search_spot_impressions" integer,
    "non_search_promoted_listings_impressions" integer,
    "percent_change_in_non_search_promoted_listings_impressions" numeric(5,2),
    "non_search_organic_impressions" integer,
    "percent_change_in_non_search_organic_impressions" numeric(5,2),
    "total_promoted_listings_impressions" integer,
    "total_organic_impressions_on_ebay_site" integer,
    "total_page_views" integer,
    "page_views_via_promoted_listings_impressions_on_ebay_site" integer,
    "page_views_via_promoted_listings_impressions_from_outside_ebay" integer,
    "page_views_via_organic_impressions_on_ebay_site" integer,
    "page_views_from_organic_impressions_outside_ebay" integer
);


ALTER TABLE "public"."traffic_history" OWNER TO "postgres";


ALTER TABLE "public"."traffic_history" ALTER COLUMN "id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME "public"."traffic_history_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."traffic_metrics" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "item_id" bigint NOT NULL,
    "measured_at" timestamp with time zone NOT NULL,
    "report_start_date" timestamp with time zone,
    "report_end_date" timestamp with time zone,
    "impressions" integer,
    "page_views" integer,
    "click_through_rate" numeric(8,4),
    "watchers" integer,
    "quantity_sold" integer,
    "conversion_rate" numeric(8,4),
    "priority_score" numeric(12,2),
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."traffic_metrics" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."users" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "username" "text",
    "email" "text",
    "password" "text",
    "usd_rate" numeric(12,4),
    "eur_rate" numeric(12,4),
    "cad_rate" numeric(12,4),
    "gbp_rate" numeric(12,4),
    "aud_rate" numeric(12,4)
);


ALTER TABLE "public"."users" OWNER TO "postgres";


ALTER TABLE "public"."users" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."users_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE OR REPLACE VIEW "public"."v_carrier_awb_totals" AS
 SELECT "s"."awb_number",
    "i"."carrier",
    "i"."invoice_number",
    "i"."invoice_date",
    "i"."currency",
    "s"."shipment_date",
    "s"."reference_1",
    COALESCE("sum"(
        CASE
            WHEN ("c"."charge_group" = 'shipping'::"text") THEN "c"."amount"
            ELSE NULL::numeric
        END), (0)::numeric) AS "actual_shipping_amount",
    COALESCE("sum"(
        CASE
            WHEN ("c"."charge_group" = 'customs'::"text") THEN "c"."amount"
            ELSE NULL::numeric
        END), (0)::numeric) AS "actual_customs_amount",
    COALESCE("sum"(
        CASE
            WHEN ("c"."charge_group" = 'fee'::"text") THEN "c"."amount"
            ELSE NULL::numeric
        END), (0)::numeric) AS "actual_fee_amount",
    COALESCE("sum"("c"."amount"), (0)::numeric) AS "actual_total_amount",
    COALESCE("sum"(
        CASE
            WHEN ("c"."charge_group" = 'fee_tax'::"text") THEN "c"."amount"
            ELSE NULL::numeric
        END), (0)::numeric) AS "actual_fee_tax_amount",
    COALESCE("sum"(
        CASE
            WHEN ("c"."charge_group" = ANY (ARRAY['fee'::"text", 'fee_tax'::"text"])) THEN "c"."amount"
            ELSE NULL::numeric
        END), (0)::numeric) AS "actual_fee_amount_incl_tax"
   FROM (("public"."carrier_shipments" "s"
     JOIN "public"."carrier_invoices" "i" ON (("i"."id" = "s"."invoice_id")))
     LEFT JOIN "public"."carrier_charges" "c" ON (("c"."shipment_id" = "s"."id")))
  GROUP BY "s"."awb_number", "i"."carrier", "i"."invoice_number", "i"."invoice_date", "i"."currency", "s"."shipment_date", "s"."reference_1";


ALTER TABLE "public"."v_carrier_awb_totals" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."webhooks" (
    "id" bigint NOT NULL,
    "account_id" bigint NOT NULL,
    "url" "text" NOT NULL,
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "event_type" "text" NOT NULL
);


ALTER TABLE "public"."webhooks" OWNER TO "postgres";


ALTER TABLE "public"."webhooks" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."webhooks_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



ALTER TABLE ONLY "public"."inventory_management_schedules" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."inventory_management_schedules_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."inventory_update_history" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."inventory_update_history_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."markdown_presets" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."markdown_presets_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."markdown_runs" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."markdown_runs_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."system_errors" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."system_errors_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."account_health_snapshots"
    ADD CONSTRAINT "account_health_snapshots_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."accounts"
    ADD CONSTRAINT "accounts_pkey" PRIMARY KEY ("id", "user_id");



ALTER TABLE ONLY "public"."ai_insights"
    ADD CONSTRAINT "ai_insights_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."app_settings"
    ADD CONSTRAINT "app_settings_pkey" PRIMARY KEY ("key");



ALTER TABLE ONLY "public"."audit_logs"
    ADD CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."buyers"
    ADD CONSTRAINT "buyers_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."carrier_charge_label_catalog"
    ADD CONSTRAINT "carrier_charge_label_catalog_carrier_normalized_label_key" UNIQUE ("carrier", "normalized_label");



ALTER TABLE ONLY "public"."carrier_charge_label_catalog"
    ADD CONSTRAINT "carrier_charge_label_catalog_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."carrier_charges"
    ADD CONSTRAINT "carrier_charges_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."carrier_invoice_anomalies"
    ADD CONSTRAINT "carrier_invoice_anomalies_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."carrier_invoice_anomalies"
    ADD CONSTRAINT "carrier_invoice_anomalies_shipment_id_anomaly_code_key" UNIQUE ("shipment_id", "anomaly_code");



ALTER TABLE ONLY "public"."carrier_invoice_import_logs"
    ADD CONSTRAINT "carrier_invoice_import_logs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."carrier_invoices"
    ADD CONSTRAINT "carrier_invoices_carrier_invoice_number_key" UNIQUE ("carrier", "invoice_number");



ALTER TABLE ONLY "public"."carrier_invoices"
    ADD CONSTRAINT "carrier_invoices_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."carrier_shipments"
    ADD CONSTRAINT "carrier_shipments_invoice_id_awb_number_key" UNIQUE ("invoice_id", "awb_number");



ALTER TABLE ONLY "public"."carrier_shipments"
    ADD CONSTRAINT "carrier_shipments_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."carrier_unknown_charge_events"
    ADD CONSTRAINT "carrier_unknown_charge_events_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."carrier_unknown_charge_events"
    ADD CONSTRAINT "carrier_unknown_charge_events_shipment_id_normalized_label__key" UNIQUE ("shipment_id", "normalized_label", "line_no");



ALTER TABLE ONLY "public"."case_events"
    ADD CONSTRAINT "case_events_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."case_items"
    ADD CONSTRAINT "case_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."case_memos"
    ADD CONSTRAINT "case_memos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."case_records"
    ADD CONSTRAINT "case_records_ebay_case_id_key" UNIQUE ("ebay_case_id");



ALTER TABLE ONLY "public"."case_records"
    ADD CONSTRAINT "case_records_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."categories"
    ADD CONSTRAINT "categories_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."country_codes"
    ADD CONSTRAINT "country_codes_pkey" PRIMARY KEY ("code");



ALTER TABLE ONLY "public"."daily_memos"
    ADD CONSTRAINT "daily_memos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."daily_memos"
    ADD CONSTRAINT "daily_memos_user_id_memo_date_key" UNIQUE ("user_id", "memo_date");



ALTER TABLE ONLY "public"."buyers"
    ADD CONSTRAINT "ebay_buyer_id_unique" UNIQUE ("ebay_buyer_id");



ALTER TABLE ONLY "public"."employees"
    ADD CONSTRAINT "employees_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."fixed_costs"
    ADD CONSTRAINT "fixed_costs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."hts_codes"
    ADD CONSTRAINT "hts_codes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."inventory_count_lines"
    ADD CONSTRAINT "inventory_count_lines_inventory_count_id_sku_key" UNIQUE ("inventory_count_id", "sku");



ALTER TABLE ONLY "public"."inventory_count_lines"
    ADD CONSTRAINT "inventory_count_lines_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."inventory_counts"
    ADD CONSTRAINT "inventory_counts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."inventory_locations"
    ADD CONSTRAINT "inventory_locations_code_key" UNIQUE ("code");



ALTER TABLE ONLY "public"."inventory_locations"
    ADD CONSTRAINT "inventory_locations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."inventory_management_schedules"
    ADD CONSTRAINT "inventory_management_schedules_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."inventory_statuses"
    ADD CONSTRAINT "inventory_statuses_pkey" PRIMARY KEY ("code");



ALTER TABLE ONLY "public"."inventory_units"
    ADD CONSTRAINT "inventory_units_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."inventory_update_history"
    ADD CONSTRAINT "inventory_update_history_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."items"
    ADD CONSTRAINT "items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."markdown_presets"
    ADD CONSTRAINT "markdown_presets_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."markdown_runs"
    ADD CONSTRAINT "markdown_runs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."message_templates"
    ADD CONSTRAINT "message_templates_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."message_history"
    ADD CONSTRAINT "messages_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."name_map"
    ADD CONSTRAINT "name_map_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."octoparse_accounts"
    ADD CONSTRAINT "octoparse_accounts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."octoparse_tasks"
    ADD CONSTRAINT "octoparse_tasks_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."openclaw_jobs"
    ADD CONSTRAINT "openclaw_jobs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."order_history"
    ADD CONSTRAINT "order_history_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."order_line_items"
    ADD CONSTRAINT "order_line_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."orders"
    ADD CONSTRAINT "order_no_unique" UNIQUE ("order_no");



ALTER TABLE ONLY "public"."orders"
    ADD CONSTRAINT "order_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."price_change_logs"
    ADD CONSTRAINT "price_change_logs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."price_observations"
    ADD CONSTRAINT "price_observations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."price_recommendations"
    ADD CONSTRAINT "price_recommendations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."priority_quadrants"
    ADD CONSTRAINT "priority_quadrants_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."scoring_rules"
    ADD CONSTRAINT "scoring_rules_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."scoring_rules"
    ADD CONSTRAINT "scoring_rules_version_key" UNIQUE ("version");



ALTER TABLE ONLY "public"."sheet_conversion_job_items"
    ADD CONSTRAINT "sheet_conversion_job_items_job_id_row_index_key" UNIQUE ("job_id", "row_index");



ALTER TABLE ONLY "public"."sheet_conversion_job_items"
    ADD CONSTRAINT "sheet_conversion_job_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."sheet_conversion_jobs"
    ADD CONSTRAINT "sheet_conversion_jobs_job_key_key" UNIQUE ("job_key");



ALTER TABLE ONLY "public"."sheet_conversion_jobs"
    ADD CONSTRAINT "sheet_conversion_jobs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."shipco_senders"
    ADD CONSTRAINT "shipco_senders_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."shipco_senders"
    ADD CONSTRAINT "shipco_senders_user_id_key" UNIQUE ("user_id");



ALTER TABLE ONLY "public"."shipment_group_orders"
    ADD CONSTRAINT "shipment_group_orders_pkey" PRIMARY KEY ("group_id", "order_no");



ALTER TABLE ONLY "public"."shipment_groups"
    ADD CONSTRAINT "shipment_groups_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."shipping_rates"
    ADD CONSTRAINT "shipping_rates_carrier_service_code_destination_scope_zone__key" UNIQUE ("carrier", "service_code", "destination_scope", "zone", "weight_max_g");



ALTER TABLE ONLY "public"."shipping_rates"
    ADD CONSTRAINT "shipping_rates_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."system_errors"
    ADD CONSTRAINT "system_errors_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."test"
    ADD CONSTRAINT "test_pkey" PRIMARY KEY ("id", "username");



ALTER TABLE ONLY "public"."traffic_history"
    ADD CONSTRAINT "traffic_history_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."traffic_history"
    ADD CONSTRAINT "traffic_history_unique" UNIQUE ("ebay_item_id", "report_month", "ebay_user_id");



ALTER TABLE ONLY "public"."traffic_metrics"
    ADD CONSTRAINT "traffic_metrics_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."categories"
    ADD CONSTRAINT "unique_category_id" UNIQUE ("category_id");



ALTER TABLE ONLY "public"."items"
    ADD CONSTRAINT "unique_ebay_item_id" UNIQUE ("ebay_item_id");



ALTER TABLE ONLY "public"."traffic_history"
    ADD CONSTRAINT "unique_ebay_item_id_report_month" UNIQUE ("ebay_item_id", "report_month");



ALTER TABLE ONLY "public"."items"
    ADD CONSTRAINT "unique_ebay_item_user" UNIQUE ("ebay_item_id", "ebay_user_id");



ALTER TABLE ONLY "public"."items"
    ADD CONSTRAINT "unique_ebay_item_user_id" UNIQUE ("ebay_item_id", "user_id");



ALTER TABLE ONLY "public"."octoparse_tasks"
    ADD CONSTRAINT "unique_task_id" UNIQUE ("task_id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."webhooks"
    ADD CONSTRAINT "webhooks_pkey" PRIMARY KEY ("id");



CREATE UNIQUE INDEX "accounts_id_unique" ON "public"."accounts" USING "btree" ("id");



CREATE INDEX "ai_insights_date_idx" ON "public"."ai_insights" USING "btree" ("date");



CREATE INDEX "ai_insights_user_id_idx" ON "public"."ai_insights" USING "btree" ("user_id");



CREATE INDEX "case_records_resolution_due_idx" ON "public"."case_records" USING "btree" ("resolution_due_at");



CREATE INDEX "case_records_status_idx" ON "public"."case_records" USING "btree" ("status");



CREATE INDEX "case_records_type_idx" ON "public"."case_records" USING "btree" ("case_type");



CREATE INDEX "country_codes_currency_idx" ON "public"."country_codes" USING "btree" ("currency");



CREATE INDEX "country_codes_ebay_currency_idx" ON "public"."country_codes" USING "btree" ("ebay_currency");



CREATE UNIQUE INDEX "employees_user_display_name_idx" ON "public"."employees" USING "btree" ("user_id", "display_name");



CREATE INDEX "employees_user_status_idx" ON "public"."employees" USING "btree" ("user_id", "status");



CREATE INDEX "hts_codes_hts_code_idx" ON "public"."hts_codes" USING "btree" ("hts_code");



CREATE INDEX "hts_codes_user_id_idx" ON "public"."hts_codes" USING "btree" ("user_id");



CREATE INDEX "idx_account_health_snapshots_account_measured_at" ON "public"."account_health_snapshots" USING "btree" ("account_id", "measured_at" DESC);



CREATE INDEX "idx_account_health_snapshots_ebay_user_measured_at" ON "public"."account_health_snapshots" USING "btree" ("ebay_user_id", "measured_at" DESC);



CREATE INDEX "idx_account_health_snapshots_seller_level" ON "public"."account_health_snapshots" USING "btree" ("seller_level", "measured_at" DESC);



CREATE INDEX "idx_account_health_snapshots_user_measured_at" ON "public"."account_health_snapshots" USING "btree" ("user_id", "measured_at" DESC);



CREATE INDEX "idx_carrier_charges_group" ON "public"."carrier_charges" USING "btree" ("charge_group");



CREATE INDEX "idx_carrier_charges_shipment_id" ON "public"."carrier_charges" USING "btree" ("shipment_id");



CREATE UNIQUE INDEX "idx_carrier_charges_shipment_occurrence_unique" ON "public"."carrier_charges" USING "btree" ("shipment_id", "header_occurrence_no") WHERE ("header_occurrence_no" IS NOT NULL);



CREATE INDEX "idx_carrier_invoice_anomalies_awb" ON "public"."carrier_invoice_anomalies" USING "btree" ("awb_number");



CREATE INDEX "idx_carrier_invoice_anomalies_detected" ON "public"."carrier_invoice_anomalies" USING "btree" ("last_detected_at" DESC);



CREATE INDEX "idx_carrier_invoice_anomalies_resolved_reason" ON "public"."carrier_invoice_anomalies" USING "btree" ("resolved_reason");



CREATE INDEX "idx_carrier_invoice_anomalies_status" ON "public"."carrier_invoice_anomalies" USING "btree" ("resolved", "severity");



CREATE INDEX "idx_carrier_invoice_import_logs_created_at" ON "public"."carrier_invoice_import_logs" USING "btree" ("created_at" DESC);



CREATE INDEX "idx_carrier_invoice_import_logs_run" ON "public"."carrier_invoice_import_logs" USING "btree" ("import_run_id", "created_at" DESC);



CREATE INDEX "idx_carrier_invoices_invoice_date" ON "public"."carrier_invoices" USING "btree" ("invoice_date");



CREATE INDEX "idx_carrier_shipments_awb" ON "public"."carrier_shipments" USING "btree" ("awb_number");



CREATE INDEX "idx_carrier_shipments_invoice_id" ON "public"."carrier_shipments" USING "btree" ("invoice_id");



CREATE INDEX "idx_charge_label_catalog_carrier_active" ON "public"."carrier_charge_label_catalog" USING "btree" ("carrier", "is_active");



CREATE INDEX "idx_daily_memos_date" ON "public"."daily_memos" USING "btree" ("memo_date");



CREATE INDEX "idx_daily_memos_user" ON "public"."daily_memos" USING "btree" ("user_id");



CREATE INDEX "idx_ebay_item_id" ON "public"."traffic_history" USING "btree" ("ebay_item_id");



CREATE INDEX "idx_fixed_costs_active" ON "public"."fixed_costs" USING "btree" ("active");



CREATE INDEX "idx_fixed_costs_category" ON "public"."fixed_costs" USING "btree" ("category");



CREATE INDEX "idx_fixed_costs_user_id" ON "public"."fixed_costs" USING "btree" ("user_id");



CREATE INDEX "idx_inventory_count_lines_count_sku" ON "public"."inventory_count_lines" USING "btree" ("inventory_count_id", "sku");



CREATE INDEX "idx_inventory_counts_user_counted_at" ON "public"."inventory_counts" USING "btree" ("user_id", "counted_at" DESC);



CREATE INDEX "idx_inventory_units_procurement_url" ON "public"."inventory_units" USING "btree" ("procurement_url");



CREATE INDEX "idx_inventory_units_user_location_status" ON "public"."inventory_units" USING "btree" ("user_id", "location_code", "status_code");



CREATE INDEX "idx_inventory_units_user_sku" ON "public"."inventory_units" USING "btree" ("user_id", "sku");



CREATE INDEX "idx_items_title_trgm" ON "public"."items" USING "gin" ("title" "public"."gin_trgm_ops");



CREATE INDEX "idx_items_user_exhibit_date" ON "public"."items" USING "btree" ("user_id", "exhibit_date");



CREATE INDEX "idx_items_user_research_date" ON "public"."items" USING "btree" ("user_id", "research_date");



CREATE INDEX "idx_openclaw_jobs_status_created_at" ON "public"."openclaw_jobs" USING "btree" ("status", "created_at");



CREATE INDEX "idx_order_line_items_order_id" ON "public"."order_line_items" USING "btree" ("order_no");



CREATE INDEX "idx_orders_duty_reconciled_at" ON "public"."orders" USING "btree" ("duty_reconciled_at");



CREATE INDEX "idx_orders_shipment_recorded_at" ON "public"."orders" USING "btree" ("shipment_recorded_at");



CREATE INDEX "idx_orders_shipping_reconciled_at" ON "public"."orders" USING "btree" ("shipping_reconciled_at");



CREATE INDEX "idx_orders_user_date" ON "public"."orders" USING "btree" ("user_id", "order_date");



CREATE INDEX "idx_orders_user_status_date" ON "public"."orders" USING "btree" ("user_id", "status", "order_date");



CREATE INDEX "idx_price_change_logs_item_changed_at" ON "public"."price_change_logs" USING "btree" ("item_id", "changed_at" DESC);



CREATE INDEX "idx_price_observations_item_id_observed_at" ON "public"."price_observations" USING "btree" ("item_id", "observed_at" DESC);



CREATE INDEX "idx_price_recommendations_item_status" ON "public"."price_recommendations" USING "btree" ("item_id", "status");



CREATE INDEX "idx_priority_quadrants_quadrant" ON "public"."priority_quadrants" USING "btree" ("quadrant");



CREATE INDEX "idx_priority_quadrants_user" ON "public"."priority_quadrants" USING "btree" ("user_id");



CREATE INDEX "idx_sheet_conversion_job_items_job_id_status" ON "public"."sheet_conversion_job_items" USING "btree" ("job_id", "status", "row_index");



CREATE INDEX "idx_sheet_conversion_job_items_job_id_step" ON "public"."sheet_conversion_job_items" USING "btree" ("job_id", "step", "row_index");



CREATE INDEX "idx_sheet_conversion_jobs_sheet_id_created_at" ON "public"."sheet_conversion_jobs" USING "btree" ("sheet_id", "created_at" DESC);



CREATE INDEX "idx_sheet_conversion_jobs_status_created_at" ON "public"."sheet_conversion_jobs" USING "btree" ("status", "created_at" DESC);



CREATE INDEX "idx_shipment_group_orders_order_no" ON "public"."shipment_group_orders" USING "btree" ("order_no");



CREATE INDEX "idx_shipment_groups_status" ON "public"."shipment_groups" USING "btree" ("status");



CREATE INDEX "idx_shipment_groups_user_id" ON "public"."shipment_groups" USING "btree" ("user_id");



CREATE INDEX "idx_system_errors_account_created_at" ON "public"."system_errors" USING "btree" ("account_id", "created_at" DESC);



CREATE INDEX "idx_system_errors_code_created_at" ON "public"."system_errors" USING "btree" ("error_code", "created_at" DESC);



CREATE INDEX "idx_system_errors_created_at" ON "public"."system_errors" USING "btree" ("created_at" DESC);



CREATE INDEX "idx_system_errors_user_created_at" ON "public"."system_errors" USING "btree" ("user_id", "created_at" DESC);



CREATE INDEX "idx_traffic_metrics_item_id_measured_at" ON "public"."traffic_metrics" USING "btree" ("item_id", "measured_at" DESC);



CREATE INDEX "idx_unknown_charge_events_last_detected" ON "public"."carrier_unknown_charge_events" USING "btree" ("last_detected_at" DESC);



CREATE INDEX "idx_unknown_charge_events_status" ON "public"."carrier_unknown_charge_events" USING "btree" ("resolved", "carrier");



CREATE INDEX "items_active_user_stocking_url_idx" ON "public"."items" USING "btree" ("ebay_user_id", "stocking_url") WHERE (("listing_status")::"text" = 'Active'::"text");



CREATE INDEX "items_item_title_trgm_idx" ON "public"."items" USING "gin" ("item_title" "public"."gin_trgm_ops");



CREATE INDEX "items_sku_trgm_idx" ON "public"."items" USING "gin" ("sku" "public"."gin_trgm_ops");



CREATE INDEX "items_user_ebay_listing_status_item_id_idx" ON "public"."items" USING "btree" ("user_id", "ebay_user_id", "listing_status", "ebay_item_id");



CREATE INDEX "items_user_ebay_status_idx" ON "public"."items" USING "btree" ("user_id", "ebay_user_id", "listing_status", "ebay_item_id");



CREATE INDEX "items_user_exhibit_date_exhibitor_idx" ON "public"."items" USING "btree" ("user_id", "exhibit_date", "exhibitor");



CREATE INDEX "items_user_exhibit_date_idx" ON "public"."items" USING "btree" ("user_id", "exhibit_date");



CREATE UNIQUE INDEX "items_user_id_ebay_item_id_key" ON "public"."items" USING "btree" ("user_id", "ebay_item_id");



CREATE INDEX "items_user_id_idx" ON "public"."items" USING "btree" ("user_id");



CREATE INDEX "items_user_research_date_idx" ON "public"."items" USING "btree" ("user_id", "research_date");



CREATE INDEX "items_user_research_date_researcher_idx" ON "public"."items" USING "btree" ("user_id", "research_date", "researcher");



CREATE INDEX "markdown_presets_account_id_idx" ON "public"."markdown_presets" USING "btree" ("account_id");



CREATE INDEX "markdown_runs_account_id_idx" ON "public"."markdown_runs" USING "btree" ("account_id", "executed_at" DESC);



CREATE INDEX "markdown_runs_preset_id_idx" ON "public"."markdown_runs" USING "btree" ("preset_id", "executed_at" DESC);



CREATE INDEX "name_map_user_employee_idx" ON "public"."name_map" USING "btree" ("user_id", "employee_id");



CREATE UNIQUE INDEX "name_map_user_raw_name_idx" ON "public"."name_map" USING "btree" ("user_id", "raw_name");



CREATE INDEX "order_line_items_order_no_idx" ON "public"."order_line_items" USING "btree" ("order_no");



CREATE INDEX "orders_user_order_date_idx" ON "public"."orders" USING "btree" ("user_id", "order_date");



CREATE INDEX "orders_user_order_date_researcher_idx" ON "public"."orders" USING "btree" ("user_id", "order_date", "researcher");



CREATE INDEX "orders_user_shipping_carrier_idx" ON "public"."orders" USING "btree" ("user_id", "shipping_carrier");



CREATE INDEX "orders_user_shipping_status_order_date_idx" ON "public"."orders" USING "btree" ("user_id", "shipping_status", "order_date");



CREATE INDEX "orders_user_shipping_tracking_number_idx" ON "public"."orders" USING "btree" ("user_id", "shipping_tracking_number");



CREATE INDEX "shipco_senders_user_id_idx" ON "public"."shipco_senders" USING "btree" ("user_id");



CREATE INDEX "shipping_rates_lookup_idx" ON "public"."shipping_rates" USING "btree" ("carrier", "service_code", "destination_scope", "zone", "weight_max_g");



CREATE UNIQUE INDEX "shipping_rates_unique_key" ON "public"."shipping_rates" USING "btree" ("carrier", "service_code", "destination_scope", "zone", "weight_max_g");



CREATE UNIQUE INDEX "uq_account_health_snapshots_account_measured_at" ON "public"."account_health_snapshots" USING "btree" ("account_id", "measured_at");



CREATE UNIQUE INDEX "uq_traffic_metrics_item_period" ON "public"."traffic_metrics" USING "btree" ("item_id", "report_start_date", "report_end_date");



CREATE UNIQUE INDEX "ux_shipping_rates_unique" ON "public"."shipping_rates" USING "btree" ("carrier", "service_code", "destination_scope", "zone", "weight_max_g");



CREATE INDEX "webhooks_account_id_idx" ON "public"."webhooks" USING "btree" ("account_id");



CREATE OR REPLACE TRIGGER "trg_sheet_conversion_job_items_updated_at" BEFORE UPDATE ON "public"."sheet_conversion_job_items" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at"();



CREATE OR REPLACE TRIGGER "trg_sheet_conversion_jobs_updated_at" BEFORE UPDATE ON "public"."sheet_conversion_jobs" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at"();



CREATE OR REPLACE TRIGGER "trg_shipping_rates_updated_at" BEFORE UPDATE ON "public"."shipping_rates" FOR EACH ROW EXECUTE FUNCTION "public"."set_shipping_rates_updated_at"();



ALTER TABLE ONLY "public"."account_health_snapshots"
    ADD CONSTRAINT "account_health_snapshots_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "public"."accounts"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."order_history"
    ADD CONSTRAINT "buyer_id_fk" FOREIGN KEY ("buyer_id") REFERENCES "public"."buyers"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."carrier_charges"
    ADD CONSTRAINT "carrier_charges_shipment_id_fkey" FOREIGN KEY ("shipment_id") REFERENCES "public"."carrier_shipments"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."carrier_invoice_anomalies"
    ADD CONSTRAINT "carrier_invoice_anomalies_invoice_id_fkey" FOREIGN KEY ("invoice_id") REFERENCES "public"."carrier_invoices"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."carrier_invoice_anomalies"
    ADD CONSTRAINT "carrier_invoice_anomalies_shipment_id_fkey" FOREIGN KEY ("shipment_id") REFERENCES "public"."carrier_shipments"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."carrier_shipments"
    ADD CONSTRAINT "carrier_shipments_invoice_id_fkey" FOREIGN KEY ("invoice_id") REFERENCES "public"."carrier_invoices"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."carrier_unknown_charge_events"
    ADD CONSTRAINT "carrier_unknown_charge_events_catalog_id_fkey" FOREIGN KEY ("catalog_id") REFERENCES "public"."carrier_charge_label_catalog"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."carrier_unknown_charge_events"
    ADD CONSTRAINT "carrier_unknown_charge_events_invoice_id_fkey" FOREIGN KEY ("invoice_id") REFERENCES "public"."carrier_invoices"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."carrier_unknown_charge_events"
    ADD CONSTRAINT "carrier_unknown_charge_events_shipment_id_fkey" FOREIGN KEY ("shipment_id") REFERENCES "public"."carrier_shipments"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."case_events"
    ADD CONSTRAINT "case_events_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "public"."case_records"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."case_items"
    ADD CONSTRAINT "case_items_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "public"."case_records"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."case_items"
    ADD CONSTRAINT "case_items_order_line_item_id_fkey" FOREIGN KEY ("order_line_item_id") REFERENCES "public"."order_line_items"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."case_memos"
    ADD CONSTRAINT "case_memos_author_user_id_fkey" FOREIGN KEY ("author_user_id") REFERENCES "public"."users"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."case_memos"
    ADD CONSTRAINT "case_memos_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "public"."case_records"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."case_records"
    ADD CONSTRAINT "case_records_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "public"."accounts"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."case_records"
    ADD CONSTRAINT "case_records_assignee_user_id_fkey" FOREIGN KEY ("assignee_user_id") REFERENCES "public"."users"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."case_records"
    ADD CONSTRAINT "case_records_buyer_id_fkey" FOREIGN KEY ("buyer_id") REFERENCES "public"."buyers"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."case_records"
    ADD CONSTRAINT "case_records_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."daily_memos"
    ADD CONSTRAINT "daily_memos_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."employees"
    ADD CONSTRAINT "employees_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."fixed_costs"
    ADD CONSTRAINT "fixed_costs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."message_history"
    ADD CONSTRAINT "fk_ebay_buyer" FOREIGN KEY ("ebay_buyer_id") REFERENCES "public"."buyers"("ebay_buyer_id");



ALTER TABLE ONLY "public"."inventory_count_lines"
    ADD CONSTRAINT "inventory_count_lines_inventory_count_id_fkey" FOREIGN KEY ("inventory_count_id") REFERENCES "public"."inventory_counts"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."inventory_counts"
    ADD CONSTRAINT "inventory_counts_location_code_fkey" FOREIGN KEY ("location_code") REFERENCES "public"."inventory_locations"("code");



ALTER TABLE ONLY "public"."inventory_management_schedules"
    ADD CONSTRAINT "inventory_management_schedules_task_id_fkey" FOREIGN KEY ("task_id") REFERENCES "public"."octoparse_tasks"("task_id");



ALTER TABLE ONLY "public"."inventory_management_schedules"
    ADD CONSTRAINT "inventory_management_schedules_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."inventory_units"
    ADD CONSTRAINT "inventory_units_location_code_fkey" FOREIGN KEY ("location_code") REFERENCES "public"."inventory_locations"("code");



ALTER TABLE ONLY "public"."inventory_units"
    ADD CONSTRAINT "inventory_units_status_code_fkey" FOREIGN KEY ("status_code") REFERENCES "public"."inventory_statuses"("code");



ALTER TABLE ONLY "public"."markdown_presets"
    ADD CONSTRAINT "markdown_presets_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "public"."accounts"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."markdown_runs"
    ADD CONSTRAINT "markdown_runs_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "public"."accounts"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."markdown_runs"
    ADD CONSTRAINT "markdown_runs_preset_id_fkey" FOREIGN KEY ("preset_id") REFERENCES "public"."markdown_presets"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."name_map"
    ADD CONSTRAINT "name_map_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "public"."employees"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."name_map"
    ADD CONSTRAINT "name_map_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."openclaw_jobs"
    ADD CONSTRAINT "openclaw_jobs_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "public"."items"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."order_line_items"
    ADD CONSTRAINT "order_line_items_order_no_fkey" FOREIGN KEY ("order_no") REFERENCES "public"."orders"("order_no") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."price_change_logs"
    ADD CONSTRAINT "price_change_logs_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "public"."items"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."price_change_logs"
    ADD CONSTRAINT "price_change_logs_openclaw_job_id_fkey" FOREIGN KEY ("openclaw_job_id") REFERENCES "public"."openclaw_jobs"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."price_change_logs"
    ADD CONSTRAINT "price_change_logs_recommendation_id_fkey" FOREIGN KEY ("recommendation_id") REFERENCES "public"."price_recommendations"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."price_observations"
    ADD CONSTRAINT "price_observations_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "public"."items"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."price_recommendations"
    ADD CONSTRAINT "price_recommendations_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "public"."items"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."price_recommendations"
    ADD CONSTRAINT "price_recommendations_metric_id_fkey" FOREIGN KEY ("metric_id") REFERENCES "public"."traffic_metrics"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."price_recommendations"
    ADD CONSTRAINT "price_recommendations_observation_id_fkey" FOREIGN KEY ("observation_id") REFERENCES "public"."price_observations"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."priority_quadrants"
    ADD CONSTRAINT "priority_quadrants_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."sheet_conversion_job_items"
    ADD CONSTRAINT "sheet_conversion_job_items_job_id_fkey" FOREIGN KEY ("job_id") REFERENCES "public"."sheet_conversion_jobs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."shipment_group_orders"
    ADD CONSTRAINT "shipment_group_orders_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "public"."shipment_groups"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."message_history"
    ADD CONSTRAINT "template_id_fk" FOREIGN KEY ("template_id") REFERENCES "public"."message_templates"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."traffic_history"
    ADD CONSTRAINT "traffic_history_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "public"."items"("id");



ALTER TABLE ONLY "public"."traffic_metrics"
    ADD CONSTRAINT "traffic_metrics_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "public"."items"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."webhooks"
    ADD CONSTRAINT "webhooks_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "public"."accounts"("id") ON DELETE CASCADE;



ALTER TABLE "public"."test" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";



GRANT ALL ON FUNCTION "public"."gtrgm_in"("cstring") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_in"("cstring") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_in"("cstring") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_in"("cstring") TO "service_role";



GRANT ALL ON FUNCTION "public"."gtrgm_out"("public"."gtrgm") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_out"("public"."gtrgm") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_out"("public"."gtrgm") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_out"("public"."gtrgm") TO "service_role";
































































































































































































GRANT ALL ON FUNCTION "public"."get_existing_stocking_urls"("p_ebay_user_id" "text", "p_urls" "text"[]) TO "anon";
GRANT ALL ON FUNCTION "public"."get_existing_stocking_urls"("p_ebay_user_id" "text", "p_urls" "text"[]) TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_existing_stocking_urls"("p_ebay_user_id" "text", "p_urls" "text"[]) TO "service_role";



GRANT ALL ON FUNCTION "public"."gin_extract_query_trgm"("text", "internal", smallint, "internal", "internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gin_extract_query_trgm"("text", "internal", smallint, "internal", "internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gin_extract_query_trgm"("text", "internal", smallint, "internal", "internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gin_extract_query_trgm"("text", "internal", smallint, "internal", "internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gin_extract_value_trgm"("text", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gin_extract_value_trgm"("text", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gin_extract_value_trgm"("text", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gin_extract_value_trgm"("text", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gin_trgm_consistent"("internal", smallint, "text", integer, "internal", "internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gin_trgm_consistent"("internal", smallint, "text", integer, "internal", "internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gin_trgm_consistent"("internal", smallint, "text", integer, "internal", "internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gin_trgm_consistent"("internal", smallint, "text", integer, "internal", "internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gin_trgm_triconsistent"("internal", smallint, "text", integer, "internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gin_trgm_triconsistent"("internal", smallint, "text", integer, "internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gin_trgm_triconsistent"("internal", smallint, "text", integer, "internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gin_trgm_triconsistent"("internal", smallint, "text", integer, "internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gtrgm_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gtrgm_consistent"("internal", "text", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_consistent"("internal", "text", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_consistent"("internal", "text", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_consistent"("internal", "text", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gtrgm_decompress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_decompress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_decompress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_decompress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gtrgm_distance"("internal", "text", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_distance"("internal", "text", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_distance"("internal", "text", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_distance"("internal", "text", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gtrgm_options"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_options"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_options"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_options"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gtrgm_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gtrgm_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gtrgm_same"("public"."gtrgm", "public"."gtrgm", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_same"("public"."gtrgm", "public"."gtrgm", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_same"("public"."gtrgm", "public"."gtrgm", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_same"("public"."gtrgm", "public"."gtrgm", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gtrgm_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."listings_summary_account_counts"("p_user_id" bigint, "p_start_date" "date", "p_end_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."listings_summary_account_counts"("p_user_id" bigint, "p_start_date" "date", "p_end_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."listings_summary_account_counts"("p_user_id" bigint, "p_start_date" "date", "p_end_date" "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."listings_summary_counts"("p_user_id" bigint, "p_start_date" "date", "p_end_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."listings_summary_counts"("p_user_id" bigint, "p_start_date" "date", "p_end_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."listings_summary_counts"("p_user_id" bigint, "p_start_date" "date", "p_end_date" "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."set_limit"(real) TO "postgres";
GRANT ALL ON FUNCTION "public"."set_limit"(real) TO "anon";
GRANT ALL ON FUNCTION "public"."set_limit"(real) TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_limit"(real) TO "service_role";



GRANT ALL ON FUNCTION "public"."set_shipping_rates_updated_at"() TO "anon";
GRANT ALL ON FUNCTION "public"."set_shipping_rates_updated_at"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_shipping_rates_updated_at"() TO "service_role";



GRANT ALL ON FUNCTION "public"."set_updated_at"() TO "anon";
GRANT ALL ON FUNCTION "public"."set_updated_at"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_updated_at"() TO "service_role";



GRANT ALL ON FUNCTION "public"."show_limit"() TO "postgres";
GRANT ALL ON FUNCTION "public"."show_limit"() TO "anon";
GRANT ALL ON FUNCTION "public"."show_limit"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."show_limit"() TO "service_role";



GRANT ALL ON FUNCTION "public"."show_trgm"("text") TO "postgres";
GRANT ALL ON FUNCTION "public"."show_trgm"("text") TO "anon";
GRANT ALL ON FUNCTION "public"."show_trgm"("text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."show_trgm"("text") TO "service_role";



GRANT ALL ON FUNCTION "public"."similarity"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."similarity"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."similarity"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."similarity"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."similarity_dist"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."similarity_dist"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."similarity_dist"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."similarity_dist"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."similarity_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."similarity_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."similarity_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."similarity_op"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."strict_word_similarity"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."strict_word_similarity"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."strict_word_similarity"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."strict_word_similarity"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."strict_word_similarity_commutator_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_commutator_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_commutator_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_commutator_op"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_commutator_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_commutator_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_commutator_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_commutator_op"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_op"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."strict_word_similarity_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_op"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."word_similarity"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."word_similarity"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."word_similarity"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."word_similarity"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."word_similarity_commutator_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."word_similarity_commutator_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."word_similarity_commutator_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."word_similarity_commutator_op"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."word_similarity_dist_commutator_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."word_similarity_dist_commutator_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."word_similarity_dist_commutator_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."word_similarity_dist_commutator_op"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."word_similarity_dist_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."word_similarity_dist_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."word_similarity_dist_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."word_similarity_dist_op"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."word_similarity_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."word_similarity_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."word_similarity_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."word_similarity_op"("text", "text") TO "service_role";





















GRANT ALL ON TABLE "public"."account_health_snapshots" TO "anon";
GRANT ALL ON TABLE "public"."account_health_snapshots" TO "authenticated";
GRANT ALL ON TABLE "public"."account_health_snapshots" TO "service_role";



GRANT ALL ON TABLE "public"."accounts" TO "anon";
GRANT ALL ON TABLE "public"."accounts" TO "authenticated";
GRANT ALL ON TABLE "public"."accounts" TO "service_role";



GRANT ALL ON SEQUENCE "public"."accounts_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."accounts_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."accounts_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."ai_insights" TO "anon";
GRANT ALL ON TABLE "public"."ai_insights" TO "authenticated";
GRANT ALL ON TABLE "public"."ai_insights" TO "service_role";



GRANT ALL ON TABLE "public"."app_settings" TO "anon";
GRANT ALL ON TABLE "public"."app_settings" TO "authenticated";
GRANT ALL ON TABLE "public"."app_settings" TO "service_role";



GRANT ALL ON TABLE "public"."audit_logs" TO "anon";
GRANT ALL ON TABLE "public"."audit_logs" TO "authenticated";
GRANT ALL ON TABLE "public"."audit_logs" TO "service_role";



GRANT ALL ON TABLE "public"."items" TO "anon";
GRANT ALL ON TABLE "public"."items" TO "authenticated";
GRANT ALL ON TABLE "public"."items" TO "service_role";



GRANT ALL ON TABLE "public"."baypilot_items" TO "anon";
GRANT ALL ON TABLE "public"."baypilot_items" TO "authenticated";
GRANT ALL ON TABLE "public"."baypilot_items" TO "service_role";



GRANT ALL ON TABLE "public"."buyers" TO "anon";
GRANT ALL ON TABLE "public"."buyers" TO "authenticated";
GRANT ALL ON TABLE "public"."buyers" TO "service_role";



GRANT ALL ON SEQUENCE "public"."buyers_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."buyers_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."buyers_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."carrier_charge_label_catalog" TO "anon";
GRANT ALL ON TABLE "public"."carrier_charge_label_catalog" TO "authenticated";
GRANT ALL ON TABLE "public"."carrier_charge_label_catalog" TO "service_role";



GRANT ALL ON TABLE "public"."carrier_charges" TO "anon";
GRANT ALL ON TABLE "public"."carrier_charges" TO "authenticated";
GRANT ALL ON TABLE "public"."carrier_charges" TO "service_role";



GRANT ALL ON TABLE "public"."carrier_invoice_anomalies" TO "anon";
GRANT ALL ON TABLE "public"."carrier_invoice_anomalies" TO "authenticated";
GRANT ALL ON TABLE "public"."carrier_invoice_anomalies" TO "service_role";



GRANT ALL ON TABLE "public"."carrier_invoice_import_logs" TO "anon";
GRANT ALL ON TABLE "public"."carrier_invoice_import_logs" TO "authenticated";
GRANT ALL ON TABLE "public"."carrier_invoice_import_logs" TO "service_role";



GRANT ALL ON TABLE "public"."carrier_invoices" TO "anon";
GRANT ALL ON TABLE "public"."carrier_invoices" TO "authenticated";
GRANT ALL ON TABLE "public"."carrier_invoices" TO "service_role";



GRANT ALL ON TABLE "public"."carrier_shipments" TO "anon";
GRANT ALL ON TABLE "public"."carrier_shipments" TO "authenticated";
GRANT ALL ON TABLE "public"."carrier_shipments" TO "service_role";



GRANT ALL ON TABLE "public"."carrier_unknown_charge_events" TO "anon";
GRANT ALL ON TABLE "public"."carrier_unknown_charge_events" TO "authenticated";
GRANT ALL ON TABLE "public"."carrier_unknown_charge_events" TO "service_role";



GRANT ALL ON TABLE "public"."case_events" TO "anon";
GRANT ALL ON TABLE "public"."case_events" TO "authenticated";
GRANT ALL ON TABLE "public"."case_events" TO "service_role";



GRANT ALL ON SEQUENCE "public"."case_events_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."case_events_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."case_events_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."case_items" TO "anon";
GRANT ALL ON TABLE "public"."case_items" TO "authenticated";
GRANT ALL ON TABLE "public"."case_items" TO "service_role";



GRANT ALL ON SEQUENCE "public"."case_items_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."case_items_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."case_items_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."case_memos" TO "anon";
GRANT ALL ON TABLE "public"."case_memos" TO "authenticated";
GRANT ALL ON TABLE "public"."case_memos" TO "service_role";



GRANT ALL ON SEQUENCE "public"."case_memos_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."case_memos_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."case_memos_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."case_records" TO "anon";
GRANT ALL ON TABLE "public"."case_records" TO "authenticated";
GRANT ALL ON TABLE "public"."case_records" TO "service_role";



GRANT ALL ON SEQUENCE "public"."case_records_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."case_records_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."case_records_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."categories" TO "anon";
GRANT ALL ON TABLE "public"."categories" TO "authenticated";
GRANT ALL ON TABLE "public"."categories" TO "service_role";



GRANT ALL ON SEQUENCE "public"."categories_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."categories_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."categories_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."country_codes" TO "anon";
GRANT ALL ON TABLE "public"."country_codes" TO "authenticated";
GRANT ALL ON TABLE "public"."country_codes" TO "service_role";



GRANT ALL ON TABLE "public"."daily_memos" TO "anon";
GRANT ALL ON TABLE "public"."daily_memos" TO "authenticated";
GRANT ALL ON TABLE "public"."daily_memos" TO "service_role";



GRANT ALL ON TABLE "public"."employees" TO "anon";
GRANT ALL ON TABLE "public"."employees" TO "authenticated";
GRANT ALL ON TABLE "public"."employees" TO "service_role";



GRANT ALL ON TABLE "public"."fixed_costs" TO "anon";
GRANT ALL ON TABLE "public"."fixed_costs" TO "authenticated";
GRANT ALL ON TABLE "public"."fixed_costs" TO "service_role";



GRANT ALL ON TABLE "public"."hts_codes" TO "anon";
GRANT ALL ON TABLE "public"."hts_codes" TO "authenticated";
GRANT ALL ON TABLE "public"."hts_codes" TO "service_role";



GRANT ALL ON TABLE "public"."inventory_count_lines" TO "anon";
GRANT ALL ON TABLE "public"."inventory_count_lines" TO "authenticated";
GRANT ALL ON TABLE "public"."inventory_count_lines" TO "service_role";



GRANT ALL ON TABLE "public"."inventory_counts" TO "anon";
GRANT ALL ON TABLE "public"."inventory_counts" TO "authenticated";
GRANT ALL ON TABLE "public"."inventory_counts" TO "service_role";



GRANT ALL ON TABLE "public"."inventory_locations" TO "anon";
GRANT ALL ON TABLE "public"."inventory_locations" TO "authenticated";
GRANT ALL ON TABLE "public"."inventory_locations" TO "service_role";



GRANT ALL ON TABLE "public"."inventory_management_schedules" TO "anon";
GRANT ALL ON TABLE "public"."inventory_management_schedules" TO "authenticated";
GRANT ALL ON TABLE "public"."inventory_management_schedules" TO "service_role";



GRANT ALL ON SEQUENCE "public"."inventory_management_schedules_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."inventory_management_schedules_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."inventory_management_schedules_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."inventory_statuses" TO "anon";
GRANT ALL ON TABLE "public"."inventory_statuses" TO "authenticated";
GRANT ALL ON TABLE "public"."inventory_statuses" TO "service_role";



GRANT ALL ON TABLE "public"."inventory_units" TO "anon";
GRANT ALL ON TABLE "public"."inventory_units" TO "authenticated";
GRANT ALL ON TABLE "public"."inventory_units" TO "service_role";



GRANT ALL ON TABLE "public"."inventory_update_history" TO "anon";
GRANT ALL ON TABLE "public"."inventory_update_history" TO "authenticated";
GRANT ALL ON TABLE "public"."inventory_update_history" TO "service_role";



GRANT ALL ON SEQUENCE "public"."inventory_update_history_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."inventory_update_history_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."inventory_update_history_id_seq" TO "service_role";



GRANT ALL ON SEQUENCE "public"."items_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."items_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."items_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."markdown_presets" TO "anon";
GRANT ALL ON TABLE "public"."markdown_presets" TO "authenticated";
GRANT ALL ON TABLE "public"."markdown_presets" TO "service_role";



GRANT ALL ON SEQUENCE "public"."markdown_presets_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."markdown_presets_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."markdown_presets_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."markdown_runs" TO "anon";
GRANT ALL ON TABLE "public"."markdown_runs" TO "authenticated";
GRANT ALL ON TABLE "public"."markdown_runs" TO "service_role";



GRANT ALL ON SEQUENCE "public"."markdown_runs_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."markdown_runs_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."markdown_runs_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."message_history" TO "anon";
GRANT ALL ON TABLE "public"."message_history" TO "authenticated";
GRANT ALL ON TABLE "public"."message_history" TO "service_role";



GRANT ALL ON TABLE "public"."message_templates" TO "anon";
GRANT ALL ON TABLE "public"."message_templates" TO "authenticated";
GRANT ALL ON TABLE "public"."message_templates" TO "service_role";



GRANT ALL ON SEQUENCE "public"."message_templates_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."message_templates_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."message_templates_id_seq" TO "service_role";



GRANT ALL ON SEQUENCE "public"."messages_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."messages_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."messages_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."name_map" TO "anon";
GRANT ALL ON TABLE "public"."name_map" TO "authenticated";
GRANT ALL ON TABLE "public"."name_map" TO "service_role";



GRANT ALL ON TABLE "public"."octoparse_accounts" TO "anon";
GRANT ALL ON TABLE "public"."octoparse_accounts" TO "authenticated";
GRANT ALL ON TABLE "public"."octoparse_accounts" TO "service_role";



GRANT ALL ON SEQUENCE "public"."octoparse_accounts_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."octoparse_accounts_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."octoparse_accounts_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."octoparse_tasks" TO "anon";
GRANT ALL ON TABLE "public"."octoparse_tasks" TO "authenticated";
GRANT ALL ON TABLE "public"."octoparse_tasks" TO "service_role";



GRANT ALL ON TABLE "public"."openclaw_jobs" TO "anon";
GRANT ALL ON TABLE "public"."openclaw_jobs" TO "authenticated";
GRANT ALL ON TABLE "public"."openclaw_jobs" TO "service_role";



GRANT ALL ON TABLE "public"."order_history" TO "anon";
GRANT ALL ON TABLE "public"."order_history" TO "authenticated";
GRANT ALL ON TABLE "public"."order_history" TO "service_role";



GRANT ALL ON SEQUENCE "public"."order_history_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."order_history_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."order_history_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."orders" TO "anon";
GRANT ALL ON TABLE "public"."orders" TO "authenticated";
GRANT ALL ON TABLE "public"."orders" TO "service_role";



GRANT ALL ON SEQUENCE "public"."order_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."order_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."order_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."order_line_items" TO "anon";
GRANT ALL ON TABLE "public"."order_line_items" TO "authenticated";
GRANT ALL ON TABLE "public"."order_line_items" TO "service_role";



GRANT ALL ON TABLE "public"."price_change_logs" TO "anon";
GRANT ALL ON TABLE "public"."price_change_logs" TO "authenticated";
GRANT ALL ON TABLE "public"."price_change_logs" TO "service_role";



GRANT ALL ON TABLE "public"."price_observations" TO "anon";
GRANT ALL ON TABLE "public"."price_observations" TO "authenticated";
GRANT ALL ON TABLE "public"."price_observations" TO "service_role";



GRANT ALL ON TABLE "public"."price_recommendations" TO "anon";
GRANT ALL ON TABLE "public"."price_recommendations" TO "authenticated";
GRANT ALL ON TABLE "public"."price_recommendations" TO "service_role";



GRANT ALL ON TABLE "public"."priority_quadrants" TO "anon";
GRANT ALL ON TABLE "public"."priority_quadrants" TO "authenticated";
GRANT ALL ON TABLE "public"."priority_quadrants" TO "service_role";



GRANT ALL ON TABLE "public"."scoring_rules" TO "anon";
GRANT ALL ON TABLE "public"."scoring_rules" TO "authenticated";
GRANT ALL ON TABLE "public"."scoring_rules" TO "service_role";



GRANT ALL ON TABLE "public"."sheet_conversion_job_items" TO "anon";
GRANT ALL ON TABLE "public"."sheet_conversion_job_items" TO "authenticated";
GRANT ALL ON TABLE "public"."sheet_conversion_job_items" TO "service_role";



GRANT ALL ON SEQUENCE "public"."sheet_conversion_job_items_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."sheet_conversion_job_items_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."sheet_conversion_job_items_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."sheet_conversion_jobs" TO "anon";
GRANT ALL ON TABLE "public"."sheet_conversion_jobs" TO "authenticated";
GRANT ALL ON TABLE "public"."sheet_conversion_jobs" TO "service_role";



GRANT ALL ON TABLE "public"."sheet_conversion_job_progress" TO "anon";
GRANT ALL ON TABLE "public"."sheet_conversion_job_progress" TO "authenticated";
GRANT ALL ON TABLE "public"."sheet_conversion_job_progress" TO "service_role";



GRANT ALL ON TABLE "public"."shipco_senders" TO "anon";
GRANT ALL ON TABLE "public"."shipco_senders" TO "authenticated";
GRANT ALL ON TABLE "public"."shipco_senders" TO "service_role";



GRANT ALL ON TABLE "public"."shipment_group_orders" TO "anon";
GRANT ALL ON TABLE "public"."shipment_group_orders" TO "authenticated";
GRANT ALL ON TABLE "public"."shipment_group_orders" TO "service_role";



GRANT ALL ON TABLE "public"."shipment_groups" TO "anon";
GRANT ALL ON TABLE "public"."shipment_groups" TO "authenticated";
GRANT ALL ON TABLE "public"."shipment_groups" TO "service_role";



GRANT ALL ON TABLE "public"."shipping_rates" TO "anon";
GRANT ALL ON TABLE "public"."shipping_rates" TO "authenticated";
GRANT ALL ON TABLE "public"."shipping_rates" TO "service_role";



GRANT ALL ON TABLE "public"."system_errors" TO "anon";
GRANT ALL ON TABLE "public"."system_errors" TO "authenticated";
GRANT ALL ON TABLE "public"."system_errors" TO "service_role";



GRANT ALL ON SEQUENCE "public"."system_errors_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."system_errors_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."system_errors_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."test" TO "anon";
GRANT ALL ON TABLE "public"."test" TO "authenticated";
GRANT ALL ON TABLE "public"."test" TO "service_role";



GRANT ALL ON SEQUENCE "public"."test_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."test_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."test_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."traffic_history" TO "anon";
GRANT ALL ON TABLE "public"."traffic_history" TO "authenticated";
GRANT ALL ON TABLE "public"."traffic_history" TO "service_role";



GRANT ALL ON SEQUENCE "public"."traffic_history_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."traffic_history_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."traffic_history_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."traffic_metrics" TO "anon";
GRANT ALL ON TABLE "public"."traffic_metrics" TO "authenticated";
GRANT ALL ON TABLE "public"."traffic_metrics" TO "service_role";



GRANT ALL ON TABLE "public"."users" TO "anon";
GRANT ALL ON TABLE "public"."users" TO "authenticated";
GRANT ALL ON TABLE "public"."users" TO "service_role";



GRANT ALL ON SEQUENCE "public"."users_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."users_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."users_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."v_carrier_awb_totals" TO "anon";
GRANT ALL ON TABLE "public"."v_carrier_awb_totals" TO "authenticated";
GRANT ALL ON TABLE "public"."v_carrier_awb_totals" TO "service_role";



GRANT ALL ON TABLE "public"."webhooks" TO "anon";
GRANT ALL ON TABLE "public"."webhooks" TO "authenticated";
GRANT ALL ON TABLE "public"."webhooks" TO "service_role";



GRANT ALL ON SEQUENCE "public"."webhooks_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."webhooks_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."webhooks_id_seq" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";






























drop extension if exists "pg_net";


