
  create table "public"."manager_goals" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" bigint not null,
    "domain" text not null default 'ebay'::text,
    "account_id" bigint,
    "name" text not null,
    "description" text,
    "goal_type" text not null default 'mid_term'::text,
    "target_value" numeric(18,4),
    "current_value" numeric(18,4),
    "unit" text,
    "deadline" date,
    "priority" smallint not null default 3,
    "status" text not null default 'active'::text,
    "metadata" jsonb not null default '{}'::jsonb,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );



  create table "public"."manager_kpis" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" bigint not null,
    "goal_id" uuid not null,
    "domain" text not null default 'ebay'::text,
    "name" text not null,
    "description" text,
    "target_value" numeric(18,4),
    "current_value" numeric(18,4),
    "unit" text,
    "direction" text not null default 'increase'::text,
    "status" text not null default 'active'::text,
    "warning_threshold" numeric(18,4),
    "critical_threshold" numeric(18,4),
    "metadata" jsonb not null default '{}'::jsonb,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );



  create table "public"."manager_plans" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" bigint not null,
    "goal_id" uuid not null,
    "domain" text not null default 'ebay'::text,
    "name" text not null,
    "description" text,
    "timeframe" text not null,
    "status" text not null default 'active'::text,
    "owner_user_id" bigint,
    "metadata" jsonb not null default '{}'::jsonb,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );



  create table "public"."manager_task_schedules" (
    "id" uuid not null default gen_random_uuid(),
    "task_id" uuid not null,
    "scheduled_start" timestamp with time zone not null,
    "scheduled_end" timestamp with time zone,
    "notification_required" boolean not null default false,
    "calendar_provider" text not null default 'internal'::text,
    "external_event_id" text,
    "rule_basis" text,
    "sync_status" text not null default 'pending'::text,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );



  create table "public"."manager_tasks" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" bigint not null,
    "domain" text not null default 'ebay'::text,
    "account_id" bigint,
    "item_id" bigint,
    "order_id" bigint,
    "title" text not null,
    "description" text,
    "task_type" text not null default 'manual_followup'::text,
    "priority" text not null default 'medium'::text,
    "status" text not null default 'draft'::text,
    "due_date" date,
    "estimated_minutes" integer,
    "source_type" text not null default 'manual'::text,
    "source_report_id" text,
    "source_payload" jsonb,
    "reason" text,
    "related_goal_id" uuid,
    "related_plan_id" uuid,
    "related_kpi_id" uuid,
    "notion_page_id" text,
    "notion_last_synced_at" timestamp with time zone,
    "metadata" jsonb not null default '{}'::jsonb,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now(),
    "completed_at" timestamp with time zone
      );


alter table "public"."carrier_invoices" add column "due_date" date;

alter table "public"."carrier_invoices" add column "error_message" text;

alter table "public"."carrier_invoices" add column "import_run_id" uuid;

alter table "public"."carrier_invoices" add column "imported_at" timestamp with time zone;

alter table "public"."carrier_invoices" add column "invoice_total_amount" numeric(12,2);

alter table "public"."carrier_invoices" add column "last_imported_at" timestamp with time zone;

alter table "public"."carrier_invoices" add column "raw_payload" jsonb;

alter table "public"."carrier_invoices" add column "source_message_id" text;

alter table "public"."carrier_invoices" add column "status" text not null default 'pending'::text;

alter table "public"."carrier_invoices" add column "updated_at" timestamp with time zone not null default now();

alter table "public"."order_line_items" add column "procurement_entries" jsonb not null default '[]'::jsonb;

CREATE INDEX idx_carrier_invoices_due_date ON public.carrier_invoices USING btree (due_date);

CREATE INDEX idx_carrier_invoices_import_run_id ON public.carrier_invoices USING btree (import_run_id);

CREATE INDEX idx_carrier_invoices_imported_at ON public.carrier_invoices USING btree (imported_at DESC);

CREATE INDEX idx_carrier_invoices_status ON public.carrier_invoices USING btree (status);

CREATE INDEX idx_manager_goals_deadline ON public.manager_goals USING btree (deadline);

CREATE INDEX idx_manager_goals_user_domain_status ON public.manager_goals USING btree (user_id, domain, status);

CREATE INDEX idx_manager_kpis_goal_status ON public.manager_kpis USING btree (goal_id, status);

CREATE INDEX idx_manager_plans_goal_status ON public.manager_plans USING btree (goal_id, status);

CREATE INDEX idx_manager_task_schedules_task_start ON public.manager_task_schedules USING btree (task_id, scheduled_start);

CREATE INDEX idx_manager_tasks_notion_page_id ON public.manager_tasks USING btree (notion_page_id);

CREATE INDEX idx_manager_tasks_related_goal ON public.manager_tasks USING btree (related_goal_id);

CREATE INDEX idx_manager_tasks_related_kpi ON public.manager_tasks USING btree (related_kpi_id);

CREATE INDEX idx_manager_tasks_related_plan ON public.manager_tasks USING btree (related_plan_id);

CREATE INDEX idx_manager_tasks_source ON public.manager_tasks USING btree (source_type, source_report_id);

CREATE INDEX idx_manager_tasks_user_status_due ON public.manager_tasks USING btree (user_id, status, due_date);

CREATE UNIQUE INDEX manager_goals_pkey ON public.manager_goals USING btree (id);

CREATE UNIQUE INDEX manager_kpis_pkey ON public.manager_kpis USING btree (id);

CREATE UNIQUE INDEX manager_plans_pkey ON public.manager_plans USING btree (id);

CREATE UNIQUE INDEX manager_task_schedules_pkey ON public.manager_task_schedules USING btree (id);

CREATE UNIQUE INDEX manager_tasks_pkey ON public.manager_tasks USING btree (id);

alter table "public"."manager_goals" add constraint "manager_goals_pkey" PRIMARY KEY using index "manager_goals_pkey";

alter table "public"."manager_kpis" add constraint "manager_kpis_pkey" PRIMARY KEY using index "manager_kpis_pkey";

alter table "public"."manager_plans" add constraint "manager_plans_pkey" PRIMARY KEY using index "manager_plans_pkey";

alter table "public"."manager_task_schedules" add constraint "manager_task_schedules_pkey" PRIMARY KEY using index "manager_task_schedules_pkey";

alter table "public"."manager_tasks" add constraint "manager_tasks_pkey" PRIMARY KEY using index "manager_tasks_pkey";

alter table "public"."carrier_invoices" add constraint "carrier_invoices_status_check" CHECK ((status = ANY (ARRAY['pending'::text, 'imported'::text, 'failed'::text, 'skipped'::text]))) not valid;

alter table "public"."carrier_invoices" validate constraint "carrier_invoices_status_check";

alter table "public"."manager_goals" add constraint "manager_goals_goal_type_check" CHECK ((goal_type = ANY (ARRAY['long_term'::text, 'mid_term'::text, 'short_term'::text]))) not valid;

alter table "public"."manager_goals" validate constraint "manager_goals_goal_type_check";

alter table "public"."manager_goals" add constraint "manager_goals_priority_check" CHECK (((priority >= 1) AND (priority <= 5))) not valid;

alter table "public"."manager_goals" validate constraint "manager_goals_priority_check";

alter table "public"."manager_goals" add constraint "manager_goals_status_check" CHECK ((status = ANY (ARRAY['draft'::text, 'active'::text, 'on_track'::text, 'at_risk'::text, 'paused'::text, 'completed'::text, 'archived'::text]))) not valid;

alter table "public"."manager_goals" validate constraint "manager_goals_status_check";

alter table "public"."manager_goals" add constraint "manager_goals_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."manager_goals" validate constraint "manager_goals_user_id_fkey";

alter table "public"."manager_kpis" add constraint "manager_kpis_direction_check" CHECK ((direction = ANY (ARRAY['increase'::text, 'decrease'::text, 'maintain'::text]))) not valid;

alter table "public"."manager_kpis" validate constraint "manager_kpis_direction_check";

alter table "public"."manager_kpis" add constraint "manager_kpis_goal_id_fkey" FOREIGN KEY (goal_id) REFERENCES public.manager_goals(id) ON DELETE CASCADE not valid;

alter table "public"."manager_kpis" validate constraint "manager_kpis_goal_id_fkey";

alter table "public"."manager_kpis" add constraint "manager_kpis_status_check" CHECK ((status = ANY (ARRAY['draft'::text, 'active'::text, 'on_track'::text, 'at_risk'::text, 'paused'::text, 'completed'::text, 'archived'::text]))) not valid;

alter table "public"."manager_kpis" validate constraint "manager_kpis_status_check";

alter table "public"."manager_kpis" add constraint "manager_kpis_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."manager_kpis" validate constraint "manager_kpis_user_id_fkey";

alter table "public"."manager_plans" add constraint "manager_plans_goal_id_fkey" FOREIGN KEY (goal_id) REFERENCES public.manager_goals(id) ON DELETE CASCADE not valid;

alter table "public"."manager_plans" validate constraint "manager_plans_goal_id_fkey";

alter table "public"."manager_plans" add constraint "manager_plans_owner_user_id_fkey" FOREIGN KEY (owner_user_id) REFERENCES public.users(id) ON DELETE SET NULL not valid;

alter table "public"."manager_plans" validate constraint "manager_plans_owner_user_id_fkey";

alter table "public"."manager_plans" add constraint "manager_plans_status_check" CHECK ((status = ANY (ARRAY['draft'::text, 'active'::text, 'on_track'::text, 'at_risk'::text, 'paused'::text, 'completed'::text, 'archived'::text]))) not valid;

alter table "public"."manager_plans" validate constraint "manager_plans_status_check";

alter table "public"."manager_plans" add constraint "manager_plans_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."manager_plans" validate constraint "manager_plans_user_id_fkey";

alter table "public"."manager_task_schedules" add constraint "manager_task_schedules_provider_check" CHECK ((calendar_provider = ANY (ARRAY['internal'::text, 'apple_calendar'::text, 'notion_calendar'::text, 'google_calendar'::text]))) not valid;

alter table "public"."manager_task_schedules" validate constraint "manager_task_schedules_provider_check";

alter table "public"."manager_task_schedules" add constraint "manager_task_schedules_sync_status_check" CHECK ((sync_status = ANY (ARRAY['pending'::text, 'synced'::text, 'failed'::text, 'canceled'::text]))) not valid;

alter table "public"."manager_task_schedules" validate constraint "manager_task_schedules_sync_status_check";

alter table "public"."manager_task_schedules" add constraint "manager_task_schedules_task_id_fkey" FOREIGN KEY (task_id) REFERENCES public.manager_tasks(id) ON DELETE CASCADE not valid;

alter table "public"."manager_task_schedules" validate constraint "manager_task_schedules_task_id_fkey";

alter table "public"."manager_task_schedules" add constraint "manager_task_schedules_window_check" CHECK (((scheduled_end IS NULL) OR (scheduled_end >= scheduled_start))) not valid;

alter table "public"."manager_task_schedules" validate constraint "manager_task_schedules_window_check";

alter table "public"."manager_tasks" add constraint "manager_tasks_estimated_minutes_check" CHECK (((estimated_minutes IS NULL) OR (estimated_minutes >= 0))) not valid;

alter table "public"."manager_tasks" validate constraint "manager_tasks_estimated_minutes_check";

alter table "public"."manager_tasks" add constraint "manager_tasks_item_id_fkey" FOREIGN KEY (item_id) REFERENCES public.items(id) ON DELETE SET NULL not valid;

alter table "public"."manager_tasks" validate constraint "manager_tasks_item_id_fkey";

alter table "public"."manager_tasks" add constraint "manager_tasks_order_id_fkey" FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE SET NULL not valid;

alter table "public"."manager_tasks" validate constraint "manager_tasks_order_id_fkey";

alter table "public"."manager_tasks" add constraint "manager_tasks_priority_check" CHECK ((priority = ANY (ARRAY['high'::text, 'medium'::text, 'low'::text]))) not valid;

alter table "public"."manager_tasks" validate constraint "manager_tasks_priority_check";

alter table "public"."manager_tasks" add constraint "manager_tasks_related_goal_id_fkey" FOREIGN KEY (related_goal_id) REFERENCES public.manager_goals(id) ON DELETE SET NULL not valid;

alter table "public"."manager_tasks" validate constraint "manager_tasks_related_goal_id_fkey";

alter table "public"."manager_tasks" add constraint "manager_tasks_related_kpi_id_fkey" FOREIGN KEY (related_kpi_id) REFERENCES public.manager_kpis(id) ON DELETE SET NULL not valid;

alter table "public"."manager_tasks" validate constraint "manager_tasks_related_kpi_id_fkey";

alter table "public"."manager_tasks" add constraint "manager_tasks_related_plan_id_fkey" FOREIGN KEY (related_plan_id) REFERENCES public.manager_plans(id) ON DELETE SET NULL not valid;

alter table "public"."manager_tasks" validate constraint "manager_tasks_related_plan_id_fkey";

alter table "public"."manager_tasks" add constraint "manager_tasks_source_type_check" CHECK ((source_type = ANY (ARRAY['sales_summary'::text, 'listings_summary'::text, 'traffic_anomalies'::text, 'risk_summary'::text, 'manual'::text]))) not valid;

alter table "public"."manager_tasks" validate constraint "manager_tasks_source_type_check";

alter table "public"."manager_tasks" add constraint "manager_tasks_status_check" CHECK ((status = ANY (ARRAY['draft'::text, 'active'::text, 'on_track'::text, 'at_risk'::text, 'paused'::text, 'completed'::text, 'archived'::text]))) not valid;

alter table "public"."manager_tasks" validate constraint "manager_tasks_status_check";

alter table "public"."manager_tasks" add constraint "manager_tasks_type_check" CHECK ((task_type = ANY (ARRAY['pricing_review'::text, 'inventory_check'::text, 'listing_research'::text, 'title_improvement'::text, 'margin_review'::text, 'traffic_investigation'::text, 'manual_followup'::text]))) not valid;

alter table "public"."manager_tasks" validate constraint "manager_tasks_type_check";

alter table "public"."manager_tasks" add constraint "manager_tasks_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."manager_tasks" validate constraint "manager_tasks_user_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.set_updated_at_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
begin
  new.updated_at = now();
  return new;
end;
$function$
;

grant delete on table "public"."manager_goals" to "anon";

grant insert on table "public"."manager_goals" to "anon";

grant references on table "public"."manager_goals" to "anon";

grant select on table "public"."manager_goals" to "anon";

grant trigger on table "public"."manager_goals" to "anon";

grant truncate on table "public"."manager_goals" to "anon";

grant update on table "public"."manager_goals" to "anon";

grant delete on table "public"."manager_goals" to "authenticated";

grant insert on table "public"."manager_goals" to "authenticated";

grant references on table "public"."manager_goals" to "authenticated";

grant select on table "public"."manager_goals" to "authenticated";

grant trigger on table "public"."manager_goals" to "authenticated";

grant truncate on table "public"."manager_goals" to "authenticated";

grant update on table "public"."manager_goals" to "authenticated";

grant delete on table "public"."manager_goals" to "service_role";

grant insert on table "public"."manager_goals" to "service_role";

grant references on table "public"."manager_goals" to "service_role";

grant select on table "public"."manager_goals" to "service_role";

grant trigger on table "public"."manager_goals" to "service_role";

grant truncate on table "public"."manager_goals" to "service_role";

grant update on table "public"."manager_goals" to "service_role";

grant delete on table "public"."manager_kpis" to "anon";

grant insert on table "public"."manager_kpis" to "anon";

grant references on table "public"."manager_kpis" to "anon";

grant select on table "public"."manager_kpis" to "anon";

grant trigger on table "public"."manager_kpis" to "anon";

grant truncate on table "public"."manager_kpis" to "anon";

grant update on table "public"."manager_kpis" to "anon";

grant delete on table "public"."manager_kpis" to "authenticated";

grant insert on table "public"."manager_kpis" to "authenticated";

grant references on table "public"."manager_kpis" to "authenticated";

grant select on table "public"."manager_kpis" to "authenticated";

grant trigger on table "public"."manager_kpis" to "authenticated";

grant truncate on table "public"."manager_kpis" to "authenticated";

grant update on table "public"."manager_kpis" to "authenticated";

grant delete on table "public"."manager_kpis" to "service_role";

grant insert on table "public"."manager_kpis" to "service_role";

grant references on table "public"."manager_kpis" to "service_role";

grant select on table "public"."manager_kpis" to "service_role";

grant trigger on table "public"."manager_kpis" to "service_role";

grant truncate on table "public"."manager_kpis" to "service_role";

grant update on table "public"."manager_kpis" to "service_role";

grant delete on table "public"."manager_plans" to "anon";

grant insert on table "public"."manager_plans" to "anon";

grant references on table "public"."manager_plans" to "anon";

grant select on table "public"."manager_plans" to "anon";

grant trigger on table "public"."manager_plans" to "anon";

grant truncate on table "public"."manager_plans" to "anon";

grant update on table "public"."manager_plans" to "anon";

grant delete on table "public"."manager_plans" to "authenticated";

grant insert on table "public"."manager_plans" to "authenticated";

grant references on table "public"."manager_plans" to "authenticated";

grant select on table "public"."manager_plans" to "authenticated";

grant trigger on table "public"."manager_plans" to "authenticated";

grant truncate on table "public"."manager_plans" to "authenticated";

grant update on table "public"."manager_plans" to "authenticated";

grant delete on table "public"."manager_plans" to "service_role";

grant insert on table "public"."manager_plans" to "service_role";

grant references on table "public"."manager_plans" to "service_role";

grant select on table "public"."manager_plans" to "service_role";

grant trigger on table "public"."manager_plans" to "service_role";

grant truncate on table "public"."manager_plans" to "service_role";

grant update on table "public"."manager_plans" to "service_role";

grant delete on table "public"."manager_task_schedules" to "anon";

grant insert on table "public"."manager_task_schedules" to "anon";

grant references on table "public"."manager_task_schedules" to "anon";

grant select on table "public"."manager_task_schedules" to "anon";

grant trigger on table "public"."manager_task_schedules" to "anon";

grant truncate on table "public"."manager_task_schedules" to "anon";

grant update on table "public"."manager_task_schedules" to "anon";

grant delete on table "public"."manager_task_schedules" to "authenticated";

grant insert on table "public"."manager_task_schedules" to "authenticated";

grant references on table "public"."manager_task_schedules" to "authenticated";

grant select on table "public"."manager_task_schedules" to "authenticated";

grant trigger on table "public"."manager_task_schedules" to "authenticated";

grant truncate on table "public"."manager_task_schedules" to "authenticated";

grant update on table "public"."manager_task_schedules" to "authenticated";

grant delete on table "public"."manager_task_schedules" to "service_role";

grant insert on table "public"."manager_task_schedules" to "service_role";

grant references on table "public"."manager_task_schedules" to "service_role";

grant select on table "public"."manager_task_schedules" to "service_role";

grant trigger on table "public"."manager_task_schedules" to "service_role";

grant truncate on table "public"."manager_task_schedules" to "service_role";

grant update on table "public"."manager_task_schedules" to "service_role";

grant delete on table "public"."manager_tasks" to "anon";

grant insert on table "public"."manager_tasks" to "anon";

grant references on table "public"."manager_tasks" to "anon";

grant select on table "public"."manager_tasks" to "anon";

grant trigger on table "public"."manager_tasks" to "anon";

grant truncate on table "public"."manager_tasks" to "anon";

grant update on table "public"."manager_tasks" to "anon";

grant delete on table "public"."manager_tasks" to "authenticated";

grant insert on table "public"."manager_tasks" to "authenticated";

grant references on table "public"."manager_tasks" to "authenticated";

grant select on table "public"."manager_tasks" to "authenticated";

grant trigger on table "public"."manager_tasks" to "authenticated";

grant truncate on table "public"."manager_tasks" to "authenticated";

grant update on table "public"."manager_tasks" to "authenticated";

grant delete on table "public"."manager_tasks" to "service_role";

grant insert on table "public"."manager_tasks" to "service_role";

grant references on table "public"."manager_tasks" to "service_role";

grant select on table "public"."manager_tasks" to "service_role";

grant trigger on table "public"."manager_tasks" to "service_role";

grant truncate on table "public"."manager_tasks" to "service_role";

grant update on table "public"."manager_tasks" to "service_role";

CREATE TRIGGER trg_carrier_invoices_updated_at BEFORE UPDATE ON public.carrier_invoices FOR EACH ROW EXECUTE FUNCTION public.set_updated_at_timestamp();

CREATE TRIGGER set_manager_goals_updated_at BEFORE UPDATE ON public.manager_goals FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_manager_kpis_updated_at BEFORE UPDATE ON public.manager_kpis FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_manager_plans_updated_at BEFORE UPDATE ON public.manager_plans FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_manager_task_schedules_updated_at BEFORE UPDATE ON public.manager_task_schedules FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_manager_tasks_updated_at BEFORE UPDATE ON public.manager_tasks FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


