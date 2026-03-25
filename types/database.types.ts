export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "12.0.2 (a4e00ff)"
  }
  public: {
    Tables: {
      account_health_snapshots: {
        Row: {
          account_id: number
          account_status: string | null
          cases_closed_without_seller_resolution_count: number | null
          created_at: string
          current_evaluation_date: string | null
          current_evaluation_month: string | null
          ebay_user_id: string | null
          evaluation_reason: string | null
          feedback_metrics: Json | null
          feedback_score: number | null
          feedback_summary_raw: Json | null
          id: string
          item_not_as_described_level: string | null
          item_not_received_level: string | null
          measured_at: string
          negative_feedback_count: number | null
          neutral_feedback_count: number | null
          peer_benchmark: string | null
          positive_feedback_count: number | null
          positive_feedback_percent: number | null
          privileges_raw: Json | null
          projected_evaluation_date: string | null
          projected_evaluation_month: string | null
          projected_seller_level: string | null
          registration_program: string | null
          seller_level: string | null
          selling_limit_amount: number | null
          selling_limit_count: number | null
          selling_limit_currency: string | null
          shipping_level: string | null
          standards_current_raw: Json | null
          standards_projected_raw: Json | null
          transaction_defect_rate: number | null
          user_id: number | null
        }
        Insert: {
          account_id: number
          account_status?: string | null
          cases_closed_without_seller_resolution_count?: number | null
          created_at?: string
          current_evaluation_date?: string | null
          current_evaluation_month?: string | null
          ebay_user_id?: string | null
          evaluation_reason?: string | null
          feedback_metrics?: Json | null
          feedback_score?: number | null
          feedback_summary_raw?: Json | null
          id?: string
          item_not_as_described_level?: string | null
          item_not_received_level?: string | null
          measured_at?: string
          negative_feedback_count?: number | null
          neutral_feedback_count?: number | null
          peer_benchmark?: string | null
          positive_feedback_count?: number | null
          positive_feedback_percent?: number | null
          privileges_raw?: Json | null
          projected_evaluation_date?: string | null
          projected_evaluation_month?: string | null
          projected_seller_level?: string | null
          registration_program?: string | null
          seller_level?: string | null
          selling_limit_amount?: number | null
          selling_limit_count?: number | null
          selling_limit_currency?: string | null
          shipping_level?: string | null
          standards_current_raw?: Json | null
          standards_projected_raw?: Json | null
          transaction_defect_rate?: number | null
          user_id?: number | null
        }
        Update: {
          account_id?: number
          account_status?: string | null
          cases_closed_without_seller_resolution_count?: number | null
          created_at?: string
          current_evaluation_date?: string | null
          current_evaluation_month?: string | null
          ebay_user_id?: string | null
          evaluation_reason?: string | null
          feedback_metrics?: Json | null
          feedback_score?: number | null
          feedback_summary_raw?: Json | null
          id?: string
          item_not_as_described_level?: string | null
          item_not_received_level?: string | null
          measured_at?: string
          negative_feedback_count?: number | null
          neutral_feedback_count?: number | null
          peer_benchmark?: string | null
          positive_feedback_count?: number | null
          positive_feedback_percent?: number | null
          privileges_raw?: Json | null
          projected_evaluation_date?: string | null
          projected_evaluation_month?: string | null
          projected_seller_level?: string | null
          registration_program?: string | null
          seller_level?: string | null
          selling_limit_amount?: number | null
          selling_limit_count?: number | null
          selling_limit_currency?: string | null
          shipping_level?: string | null
          standards_current_raw?: Json | null
          standards_projected_raw?: Json | null
          transaction_defect_rate?: number | null
          user_id?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "account_health_snapshots_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "accounts"
            referencedColumns: ["id"]
          },
        ]
      }
      accounts: {
        Row: {
          access_token: string | null
          created_at: string
          ebay_user_id: string | null
          id: number
          refresh_token: string | null
          spreadsheet_id: string | null
          stock_satus_csv_upload_drive_id: string | null
          theme_color: string | null
          token_expiration: string | null
          user_id: number
        }
        Insert: {
          access_token?: string | null
          created_at?: string
          ebay_user_id?: string | null
          id?: number
          refresh_token?: string | null
          spreadsheet_id?: string | null
          stock_satus_csv_upload_drive_id?: string | null
          theme_color?: string | null
          token_expiration?: string | null
          user_id: number
        }
        Update: {
          access_token?: string | null
          created_at?: string
          ebay_user_id?: string | null
          id?: number
          refresh_token?: string | null
          spreadsheet_id?: string | null
          stock_satus_csv_upload_drive_id?: string | null
          theme_color?: string | null
          token_expiration?: string | null
          user_id?: number
        }
        Relationships: []
      }
      ai_insights: {
        Row: {
          created_at: string
          date: string
          error_message: string | null
          id: string
          input_metrics_json: Json
          model: string | null
          output_insight_json: Json | null
          usage: Json | null
          user_id: number
        }
        Insert: {
          created_at?: string
          date: string
          error_message?: string | null
          id?: string
          input_metrics_json: Json
          model?: string | null
          output_insight_json?: Json | null
          usage?: Json | null
          user_id: number
        }
        Update: {
          created_at?: string
          date?: string
          error_message?: string | null
          id?: string
          input_metrics_json?: Json
          model?: string | null
          output_insight_json?: Json | null
          usage?: Json | null
          user_id?: number
        }
        Relationships: []
      }
      app_settings: {
        Row: {
          key: string
          updated_at: string
          value: Json
        }
        Insert: {
          key: string
          updated_at?: string
          value: Json
        }
        Update: {
          key?: string
          updated_at?: string
          value?: Json
        }
        Relationships: []
      }
      audit_logs: {
        Row: {
          action: string
          actor: string
          created_at: string
          details: Json | null
          entity_id: string | null
          entity_type: string
          id: string
        }
        Insert: {
          action: string
          actor: string
          created_at?: string
          details?: Json | null
          entity_id?: string | null
          entity_type: string
          id?: string
        }
        Update: {
          action?: string
          actor?: string
          created_at?: string
          details?: Json | null
          entity_id?: string | null
          entity_type?: string
          id?: string
        }
        Relationships: []
      }
      buyers: {
        Row: {
          address: Json | null
          attention_flag: boolean | null
          created_at: string
          ebay_buyer_id: string | null
          ebay_user_id: string | null
          email: string | null
          feedback_score: number | null
          id: number
          last_message_date: string | null
          last_message_id: number | null
          last_purchase_date: string | null
          last_template_id: number | null
          last_template_name: string | null
          name: string | null
          phone_number: string | null
          registered_date: string | null
          user_id: number | null
        }
        Insert: {
          address?: Json | null
          attention_flag?: boolean | null
          created_at?: string
          ebay_buyer_id?: string | null
          ebay_user_id?: string | null
          email?: string | null
          feedback_score?: number | null
          id?: number
          last_message_date?: string | null
          last_message_id?: number | null
          last_purchase_date?: string | null
          last_template_id?: number | null
          last_template_name?: string | null
          name?: string | null
          phone_number?: string | null
          registered_date?: string | null
          user_id?: number | null
        }
        Update: {
          address?: Json | null
          attention_flag?: boolean | null
          created_at?: string
          ebay_buyer_id?: string | null
          ebay_user_id?: string | null
          email?: string | null
          feedback_score?: number | null
          id?: number
          last_message_date?: string | null
          last_message_id?: number | null
          last_purchase_date?: string | null
          last_template_id?: number | null
          last_template_name?: string | null
          name?: string | null
          phone_number?: string | null
          registered_date?: string | null
          user_id?: number | null
        }
        Relationships: []
      }
      carrier_charge_label_catalog: {
        Row: {
          carrier: string
          created_at: string
          default_group: string
          id: string
          is_active: boolean
          is_known: boolean
          label_raw: string
          normalized_label: string
          note: string | null
          updated_at: string
          updated_by: string | null
        }
        Insert: {
          carrier: string
          created_at?: string
          default_group: string
          id?: string
          is_active?: boolean
          is_known?: boolean
          label_raw: string
          normalized_label: string
          note?: string | null
          updated_at?: string
          updated_by?: string | null
        }
        Update: {
          carrier?: string
          created_at?: string
          default_group?: string
          id?: string
          is_active?: boolean
          is_known?: boolean
          label_raw?: string
          normalized_label?: string
          note?: string | null
          updated_at?: string
          updated_by?: string | null
        }
        Relationships: []
      }
      carrier_charges: {
        Row: {
          amount: number
          charge_code: string | null
          charge_group: string
          charge_name_raw: string
          created_at: string
          header_occurrence_no: number | null
          id: string
          invoice_category: string | null
          line_no: number | null
          shipment_id: string
        }
        Insert: {
          amount: number
          charge_code?: string | null
          charge_group: string
          charge_name_raw: string
          created_at?: string
          header_occurrence_no?: number | null
          id?: string
          invoice_category?: string | null
          line_no?: number | null
          shipment_id: string
        }
        Update: {
          amount?: number
          charge_code?: string | null
          charge_group?: string
          charge_name_raw?: string
          created_at?: string
          header_occurrence_no?: number | null
          id?: string
          invoice_category?: string | null
          line_no?: number | null
          shipment_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "carrier_charges_shipment_id_fkey"
            columns: ["shipment_id"]
            isOneToOne: false
            referencedRelation: "carrier_shipments"
            referencedColumns: ["id"]
          },
        ]
      }
      carrier_invoice_anomalies: {
        Row: {
          anomaly_code: string
          awb_number: string
          buyer_country_code: string | null
          carrier: string
          created_at: string
          customs_amount: number | null
          details: Json
          ebay_user_id: string | null
          fee_amount: number | null
          fee_amount_incl_tax: number | null
          fee_tax_amount: number | null
          first_detected_at: string
          id: string
          invoice_id: string | null
          invoice_number: string | null
          last_detected_at: string
          message: string
          order_id: number | null
          order_no: string | null
          resolved: boolean
          resolved_at: string | null
          resolved_by: string | null
          resolved_note: string | null
          resolved_reason: string | null
          severity: string
          shipment_id: string
          shipping_amount: number | null
          total_amount: number | null
          updated_at: string
        }
        Insert: {
          anomaly_code: string
          awb_number: string
          buyer_country_code?: string | null
          carrier: string
          created_at?: string
          customs_amount?: number | null
          details?: Json
          ebay_user_id?: string | null
          fee_amount?: number | null
          fee_amount_incl_tax?: number | null
          fee_tax_amount?: number | null
          first_detected_at?: string
          id?: string
          invoice_id?: string | null
          invoice_number?: string | null
          last_detected_at?: string
          message: string
          order_id?: number | null
          order_no?: string | null
          resolved?: boolean
          resolved_at?: string | null
          resolved_by?: string | null
          resolved_note?: string | null
          resolved_reason?: string | null
          severity: string
          shipment_id: string
          shipping_amount?: number | null
          total_amount?: number | null
          updated_at?: string
        }
        Update: {
          anomaly_code?: string
          awb_number?: string
          buyer_country_code?: string | null
          carrier?: string
          created_at?: string
          customs_amount?: number | null
          details?: Json
          ebay_user_id?: string | null
          fee_amount?: number | null
          fee_amount_incl_tax?: number | null
          fee_tax_amount?: number | null
          first_detected_at?: string
          id?: string
          invoice_id?: string | null
          invoice_number?: string | null
          last_detected_at?: string
          message?: string
          order_id?: number | null
          order_no?: string | null
          resolved?: boolean
          resolved_at?: string | null
          resolved_by?: string | null
          resolved_note?: string | null
          resolved_reason?: string | null
          severity?: string
          shipment_id?: string
          shipping_amount?: number | null
          total_amount?: number | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "carrier_invoice_anomalies_invoice_id_fkey"
            columns: ["invoice_id"]
            isOneToOne: false
            referencedRelation: "carrier_invoices"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "carrier_invoice_anomalies_shipment_id_fkey"
            columns: ["shipment_id"]
            isOneToOne: false
            referencedRelation: "carrier_shipments"
            referencedColumns: ["id"]
          },
        ]
      }
      carrier_invoice_import_logs: {
        Row: {
          awb_number: string | null
          carrier: string
          charge_name_raw: string | null
          context: Json | null
          created_at: string
          header_occurrence_no: number | null
          id: string
          import_run_id: string
          invoice_number: string | null
          message: string
          raw_amount: string | null
          row_no: number | null
          severity: string
          source_file_name: string
        }
        Insert: {
          awb_number?: string | null
          carrier: string
          charge_name_raw?: string | null
          context?: Json | null
          created_at?: string
          header_occurrence_no?: number | null
          id?: string
          import_run_id: string
          invoice_number?: string | null
          message: string
          raw_amount?: string | null
          row_no?: number | null
          severity: string
          source_file_name: string
        }
        Update: {
          awb_number?: string | null
          carrier?: string
          charge_name_raw?: string | null
          context?: Json | null
          created_at?: string
          header_occurrence_no?: number | null
          id?: string
          import_run_id?: string
          invoice_number?: string | null
          message?: string
          raw_amount?: string | null
          row_no?: number | null
          severity?: string
          source_file_name?: string
        }
        Relationships: []
      }
      carrier_invoices: {
        Row: {
          billing_account: string | null
          carrier: string
          created_at: string
          currency: string | null
          id: string
          invoice_date: string | null
          invoice_number: string
          source_file_name: string | null
        }
        Insert: {
          billing_account?: string | null
          carrier: string
          created_at?: string
          currency?: string | null
          id?: string
          invoice_date?: string | null
          invoice_number: string
          source_file_name?: string | null
        }
        Update: {
          billing_account?: string | null
          carrier?: string
          created_at?: string
          currency?: string | null
          id?: string
          invoice_date?: string | null
          invoice_number?: string
          source_file_name?: string | null
        }
        Relationships: []
      }
      carrier_shipments: {
        Row: {
          awb_number: string
          carrier_actual_weight: number | null
          carrier_actual_weight_unit: string | null
          carrier_billed_weight: number | null
          carrier_billed_weight_unit: string | null
          carrier_dim_height: number | null
          carrier_dim_length: number | null
          carrier_dim_unit: string | null
          carrier_dim_width: number | null
          carrier_dimensions_raw: string | null
          carrier_weight_flag: string | null
          created_at: string
          id: string
          invoice_id: string
          reference_1: string | null
          shipment_date: string | null
          shipment_total: number | null
        }
        Insert: {
          awb_number: string
          carrier_actual_weight?: number | null
          carrier_actual_weight_unit?: string | null
          carrier_billed_weight?: number | null
          carrier_billed_weight_unit?: string | null
          carrier_dim_height?: number | null
          carrier_dim_length?: number | null
          carrier_dim_unit?: string | null
          carrier_dim_width?: number | null
          carrier_dimensions_raw?: string | null
          carrier_weight_flag?: string | null
          created_at?: string
          id?: string
          invoice_id: string
          reference_1?: string | null
          shipment_date?: string | null
          shipment_total?: number | null
        }
        Update: {
          awb_number?: string
          carrier_actual_weight?: number | null
          carrier_actual_weight_unit?: string | null
          carrier_billed_weight?: number | null
          carrier_billed_weight_unit?: string | null
          carrier_dim_height?: number | null
          carrier_dim_length?: number | null
          carrier_dim_unit?: string | null
          carrier_dim_width?: number | null
          carrier_dimensions_raw?: string | null
          carrier_weight_flag?: string | null
          created_at?: string
          id?: string
          invoice_id?: string
          reference_1?: string | null
          shipment_date?: string | null
          shipment_total?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "carrier_shipments_invoice_id_fkey"
            columns: ["invoice_id"]
            isOneToOne: false
            referencedRelation: "carrier_invoices"
            referencedColumns: ["id"]
          },
        ]
      }
      carrier_unknown_charge_events: {
        Row: {
          amount: number
          awb_number: string
          carrier: string
          catalog_id: string | null
          charge_name_raw: string
          created_at: string
          first_detected_at: string
          header_occurrence_no: number | null
          id: string
          invoice_id: string | null
          invoice_number: string | null
          last_detected_at: string
          line_no: number | null
          normalized_label: string
          resolved: boolean
          resolved_at: string | null
          shipment_id: string
          updated_at: string
        }
        Insert: {
          amount: number
          awb_number: string
          carrier: string
          catalog_id?: string | null
          charge_name_raw: string
          created_at?: string
          first_detected_at?: string
          header_occurrence_no?: number | null
          id?: string
          invoice_id?: string | null
          invoice_number?: string | null
          last_detected_at?: string
          line_no?: number | null
          normalized_label: string
          resolved?: boolean
          resolved_at?: string | null
          shipment_id: string
          updated_at?: string
        }
        Update: {
          amount?: number
          awb_number?: string
          carrier?: string
          catalog_id?: string | null
          charge_name_raw?: string
          created_at?: string
          first_detected_at?: string
          header_occurrence_no?: number | null
          id?: string
          invoice_id?: string | null
          invoice_number?: string | null
          last_detected_at?: string
          line_no?: number | null
          normalized_label?: string
          resolved?: boolean
          resolved_at?: string | null
          shipment_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "carrier_unknown_charge_events_catalog_id_fkey"
            columns: ["catalog_id"]
            isOneToOne: false
            referencedRelation: "carrier_charge_label_catalog"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "carrier_unknown_charge_events_invoice_id_fkey"
            columns: ["invoice_id"]
            isOneToOne: false
            referencedRelation: "carrier_invoices"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "carrier_unknown_charge_events_shipment_id_fkey"
            columns: ["shipment_id"]
            isOneToOne: false
            referencedRelation: "carrier_shipments"
            referencedColumns: ["id"]
          },
        ]
      }
      case_events: {
        Row: {
          case_id: number
          created_at: string | null
          event_type: string
          id: number
          occurred_at: string | null
          payload: Json | null
        }
        Insert: {
          case_id: number
          created_at?: string | null
          event_type: string
          id?: number
          occurred_at?: string | null
          payload?: Json | null
        }
        Update: {
          case_id?: number
          created_at?: string | null
          event_type?: string
          id?: number
          occurred_at?: string | null
          payload?: Json | null
        }
        Relationships: [
          {
            foreignKeyName: "case_events_case_id_fkey"
            columns: ["case_id"]
            isOneToOne: false
            referencedRelation: "case_records"
            referencedColumns: ["id"]
          },
        ]
      }
      case_items: {
        Row: {
          case_id: number
          currency_code: string | null
          id: number
          order_line_item_id: string | null
          quantity: number | null
          refund_amount: number | null
          title: string | null
        }
        Insert: {
          case_id: number
          currency_code?: string | null
          id?: number
          order_line_item_id?: string | null
          quantity?: number | null
          refund_amount?: number | null
          title?: string | null
        }
        Update: {
          case_id?: number
          currency_code?: string | null
          id?: number
          order_line_item_id?: string | null
          quantity?: number | null
          refund_amount?: number | null
          title?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "case_items_case_id_fkey"
            columns: ["case_id"]
            isOneToOne: false
            referencedRelation: "case_records"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "case_items_order_line_item_id_fkey"
            columns: ["order_line_item_id"]
            isOneToOne: false
            referencedRelation: "order_line_items"
            referencedColumns: ["id"]
          },
        ]
      }
      case_memos: {
        Row: {
          author_user_id: number | null
          body: string
          case_id: number
          created_at: string | null
          id: number
        }
        Insert: {
          author_user_id?: number | null
          body: string
          case_id: number
          created_at?: string | null
          id?: number
        }
        Update: {
          author_user_id?: number | null
          body?: string
          case_id?: number
          created_at?: string | null
          id?: number
        }
        Relationships: [
          {
            foreignKeyName: "case_memos_author_user_id_fkey"
            columns: ["author_user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "case_memos_case_id_fkey"
            columns: ["case_id"]
            isOneToOne: false
            referencedRelation: "case_records"
            referencedColumns: ["id"]
          },
        ]
      }
      case_records: {
        Row: {
          account_id: number
          assignee_user_id: number | null
          buyer_id: number | null
          case_type: string
          created_at: string | null
          currency_code: string | null
          ebay_case_id: string | null
          expected_refund: number | null
          id: number
          last_responded_at: string | null
          memo: string | null
          opened_at: string | null
          order_id: number | null
          reason: string | null
          requested_action: string | null
          resolution_due_at: string | null
          return_carrier: string | null
          return_tracking_number: string | null
          status: string
          updated_at: string | null
        }
        Insert: {
          account_id: number
          assignee_user_id?: number | null
          buyer_id?: number | null
          case_type: string
          created_at?: string | null
          currency_code?: string | null
          ebay_case_id?: string | null
          expected_refund?: number | null
          id?: number
          last_responded_at?: string | null
          memo?: string | null
          opened_at?: string | null
          order_id?: number | null
          reason?: string | null
          requested_action?: string | null
          resolution_due_at?: string | null
          return_carrier?: string | null
          return_tracking_number?: string | null
          status: string
          updated_at?: string | null
        }
        Update: {
          account_id?: number
          assignee_user_id?: number | null
          buyer_id?: number | null
          case_type?: string
          created_at?: string | null
          currency_code?: string | null
          ebay_case_id?: string | null
          expected_refund?: number | null
          id?: number
          last_responded_at?: string | null
          memo?: string | null
          opened_at?: string | null
          order_id?: number | null
          reason?: string | null
          requested_action?: string | null
          resolution_due_at?: string | null
          return_carrier?: string | null
          return_tracking_number?: string | null
          status?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "case_records_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "accounts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "case_records_assignee_user_id_fkey"
            columns: ["assignee_user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "case_records_buyer_id_fkey"
            columns: ["buyer_id"]
            isOneToOne: false
            referencedRelation: "buyers"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "case_records_order_id_fkey"
            columns: ["order_id"]
            isOneToOne: false
            referencedRelation: "orders"
            referencedColumns: ["id"]
          },
        ]
      }
      categories: {
        Row: {
          category_id: string
          category_level: number | null
          category_name: string | null
          category_path: string | null
          created_at: string | null
          id: number
          parent_category_id: string | null
        }
        Insert: {
          category_id: string
          category_level?: number | null
          category_name?: string | null
          category_path?: string | null
          created_at?: string | null
          id?: never
          parent_category_id?: string | null
        }
        Update: {
          category_id?: string
          category_level?: number | null
          category_name?: string | null
          category_path?: string | null
          created_at?: string | null
          id?: never
          parent_category_id?: string | null
        }
        Relationships: []
      }
      country_codes: {
        Row: {
          code: string
          created_at: string
          currency: string | null
          ebay_currency: string | null
          name_en: string
          name_ja: string
          updated_at: string
        }
        Insert: {
          code: string
          created_at?: string
          currency?: string | null
          ebay_currency?: string | null
          name_en: string
          name_ja: string
          updated_at?: string
        }
        Update: {
          code?: string
          created_at?: string
          currency?: string | null
          ebay_currency?: string | null
          name_en?: string
          name_ja?: string
          updated_at?: string
        }
        Relationships: []
      }
      daily_memos: {
        Row: {
          content: string
          created_at: string
          id: string
          memo_date: string
          updated_at: string
          user_id: number
        }
        Insert: {
          content: string
          created_at?: string
          id?: string
          memo_date: string
          updated_at?: string
          user_id: number
        }
        Update: {
          content?: string
          created_at?: string
          id?: string
          memo_date?: string
          updated_at?: string
          user_id?: number
        }
        Relationships: [
          {
            foreignKeyName: "daily_memos_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      employees: {
        Row: {
          account_name: string | null
          account_name_kana: string | null
          account_number: string | null
          account_type: string | null
          bank_code: string | null
          bank_name: string | null
          branch_code: string | null
          branch_name: string | null
          created_at: string
          display_name: string
          id: string
          incentive_rate: number
          payroll_name: string
          status: string
          updated_at: string
          user_id: number
        }
        Insert: {
          account_name?: string | null
          account_name_kana?: string | null
          account_number?: string | null
          account_type?: string | null
          bank_code?: string | null
          bank_name?: string | null
          branch_code?: string | null
          branch_name?: string | null
          created_at?: string
          display_name: string
          id?: string
          incentive_rate?: number
          payroll_name: string
          status?: string
          updated_at?: string
          user_id: number
        }
        Update: {
          account_name?: string | null
          account_name_kana?: string | null
          account_number?: string | null
          account_type?: string | null
          bank_code?: string | null
          bank_name?: string | null
          branch_code?: string | null
          branch_name?: string | null
          created_at?: string
          display_name?: string
          id?: string
          incentive_rate?: number
          payroll_name?: string
          status?: string
          updated_at?: string
          user_id?: number
        }
        Relationships: [
          {
            foreignKeyName: "employees_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      fixed_costs: {
        Row: {
          active: boolean
          amount_jpy: number
          billing_cycle: string
          category: string | null
          created_at: string
          end_date: string | null
          id: string
          name: string
          note: string | null
          start_date: string | null
          updated_at: string
          user_id: number
        }
        Insert: {
          active?: boolean
          amount_jpy?: number
          billing_cycle?: string
          category?: string | null
          created_at?: string
          end_date?: string | null
          id?: string
          name: string
          note?: string | null
          start_date?: string | null
          updated_at?: string
          user_id: number
        }
        Update: {
          active?: boolean
          amount_jpy?: number
          billing_cycle?: string
          category?: string | null
          created_at?: string
          end_date?: string | null
          id?: string
          name?: string
          note?: string | null
          start_date?: string | null
          updated_at?: string
          user_id?: number
        }
        Relationships: [
          {
            foreignKeyName: "fixed_costs_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      hts_codes: {
        Row: {
          category: string | null
          created_at: string
          duty_amount_jpy: number | null
          duty_rate_percent: number | null
          hts_code: string
          id: string
          note: string | null
          updated_at: string
          user_id: number
        }
        Insert: {
          category?: string | null
          created_at?: string
          duty_amount_jpy?: number | null
          duty_rate_percent?: number | null
          hts_code: string
          id?: string
          note?: string | null
          updated_at?: string
          user_id: number
        }
        Update: {
          category?: string | null
          created_at?: string
          duty_amount_jpy?: number | null
          duty_rate_percent?: number | null
          hts_code?: string
          id?: string
          note?: string | null
          updated_at?: string
          user_id?: number
        }
        Relationships: []
      }
      inventory_count_lines: {
        Row: {
          counted_qty: number | null
          created_at: string
          diff_qty: number | null
          diff_value_yen: number | null
          id: string
          inventory_count_id: string
          note: string | null
          sku: string
          theoretical_qty: number
          unit_cost_yen: number | null
          updated_at: string
        }
        Insert: {
          counted_qty?: number | null
          created_at?: string
          diff_qty?: number | null
          diff_value_yen?: number | null
          id?: string
          inventory_count_id: string
          note?: string | null
          sku: string
          theoretical_qty?: number
          unit_cost_yen?: number | null
          updated_at?: string
        }
        Update: {
          counted_qty?: number | null
          created_at?: string
          diff_qty?: number | null
          diff_value_yen?: number | null
          id?: string
          inventory_count_id?: string
          note?: string | null
          sku?: string
          theoretical_qty?: number
          unit_cost_yen?: number | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "inventory_count_lines_inventory_count_id_fkey"
            columns: ["inventory_count_id"]
            isOneToOne: false
            referencedRelation: "inventory_counts"
            referencedColumns: ["id"]
          },
        ]
      }
      inventory_counts: {
        Row: {
          counted_at: string
          created_at: string
          created_by: number | null
          id: string
          location_code: string
          status: string
          title: string
          updated_at: string
          user_id: number
        }
        Insert: {
          counted_at: string
          created_at?: string
          created_by?: number | null
          id?: string
          location_code: string
          status?: string
          title: string
          updated_at?: string
          user_id: number
        }
        Update: {
          counted_at?: string
          created_at?: string
          created_by?: number | null
          id?: string
          location_code?: string
          status?: string
          title?: string
          updated_at?: string
          user_id?: number
        }
        Relationships: [
          {
            foreignKeyName: "inventory_counts_location_code_fkey"
            columns: ["location_code"]
            isOneToOne: false
            referencedRelation: "inventory_locations"
            referencedColumns: ["code"]
          },
        ]
      }
      inventory_locations: {
        Row: {
          code: string
          created_at: string
          id: string
          name: string
        }
        Insert: {
          code: string
          created_at?: string
          id?: string
          name: string
        }
        Update: {
          code?: string
          created_at?: string
          id?: string
          name?: string
        }
        Relationships: []
      }
      inventory_management_schedules: {
        Row: {
          created_at: string | null
          days_of_week: number[] | null
          enabled: boolean | null
          id: number
          task_delete_flg: boolean | null
          task_id: string | null
          time_of_day: string
          updated_at: string | null
          user_id: number
        }
        Insert: {
          created_at?: string | null
          days_of_week?: number[] | null
          enabled?: boolean | null
          id?: number
          task_delete_flg?: boolean | null
          task_id?: string | null
          time_of_day: string
          updated_at?: string | null
          user_id: number
        }
        Update: {
          created_at?: string | null
          days_of_week?: number[] | null
          enabled?: boolean | null
          id?: number
          task_delete_flg?: boolean | null
          task_id?: string | null
          time_of_day?: string
          updated_at?: string | null
          user_id?: number
        }
        Relationships: [
          {
            foreignKeyName: "inventory_management_schedules_task_id_fkey"
            columns: ["task_id"]
            isOneToOne: false
            referencedRelation: "octoparse_tasks"
            referencedColumns: ["task_id"]
          },
          {
            foreignKeyName: "inventory_management_schedules_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      inventory_statuses: {
        Row: {
          code: string
          name: string
        }
        Insert: {
          code: string
          name: string
        }
        Update: {
          code?: string
          name?: string
        }
        Relationships: []
      }
      inventory_units: {
        Row: {
          condition_grade: string | null
          cost_yen: number | null
          created_at: string
          id: string
          item_id: number | null
          location_code: string
          note: string | null
          procurement_source: string | null
          procurement_url: string | null
          researcher: string | null
          sku: string
          status_code: string
          updated_at: string
          user_id: number
        }
        Insert: {
          condition_grade?: string | null
          cost_yen?: number | null
          created_at?: string
          id?: string
          item_id?: number | null
          location_code: string
          note?: string | null
          procurement_source?: string | null
          procurement_url?: string | null
          researcher?: string | null
          sku: string
          status_code: string
          updated_at?: string
          user_id: number
        }
        Update: {
          condition_grade?: string | null
          cost_yen?: number | null
          created_at?: string
          id?: string
          item_id?: number | null
          location_code?: string
          note?: string | null
          procurement_source?: string | null
          procurement_url?: string | null
          researcher?: string | null
          sku?: string
          status_code?: string
          updated_at?: string
          user_id?: number
        }
        Relationships: [
          {
            foreignKeyName: "inventory_units_location_code_fkey"
            columns: ["location_code"]
            isOneToOne: false
            referencedRelation: "inventory_locations"
            referencedColumns: ["code"]
          },
          {
            foreignKeyName: "inventory_units_status_code_fkey"
            columns: ["status_code"]
            isOneToOne: false
            referencedRelation: "inventory_statuses"
            referencedColumns: ["code"]
          },
        ]
      }
      inventory_update_history: {
        Row: {
          ebay_user_id: string | null
          error_message: string | null
          failure_count: number | null
          id: number
          log_file_id: string | null
          octoparse_task_id: string | null
          success_count: number | null
          task_delete_status: boolean | null
          update_time: string | null
          user_id: number
        }
        Insert: {
          ebay_user_id?: string | null
          error_message?: string | null
          failure_count?: number | null
          id?: number
          log_file_id?: string | null
          octoparse_task_id?: string | null
          success_count?: number | null
          task_delete_status?: boolean | null
          update_time?: string | null
          user_id: number
        }
        Update: {
          ebay_user_id?: string | null
          error_message?: string | null
          failure_count?: number | null
          id?: number
          log_file_id?: string | null
          octoparse_task_id?: string | null
          success_count?: number | null
          task_delete_status?: boolean | null
          update_time?: string | null
          user_id?: number
        }
        Relationships: []
      }
      items: {
        Row: {
          best_offer_enabled: boolean | null
          category_id: string | null
          category_level: number | null
          category_name: string | null
          category_path: string | null
          cost_price: number | null
          created_at: string
          current_price_currency: string | null
          current_price_value: number | null
          ebay_item_id: string | null
          ebay_user_id: string | null
          estimated_parcel_height: number | null
          estimated_parcel_length: number | null
          estimated_parcel_weight: number | null
          estimated_parcel_width: number | null
          estimated_shipping_cost: number | null
          exhibit_date: string | null
          exhibitor: string | null
          id: number
          item_status: string | null
          item_title: string | null
          last_synced_at: string | null
          last_update: string | null
          listing_status: string | null
          marketplace_id: string | null
          primary_image_url: string | null
          quantity: number | null
          research_date: string | null
          researcher: string | null
          selling_state: string | null
          sku: string | null
          status_synced_at: string | null
          stock_status: string | null
          stocking_url: string | null
          title: string | null
          updated_at: string | null
          user_id: number | null
          view_item_url: string | null
        }
        Insert: {
          best_offer_enabled?: boolean | null
          category_id?: string | null
          category_level?: number | null
          category_name?: string | null
          category_path?: string | null
          cost_price?: number | null
          created_at?: string
          current_price_currency?: string | null
          current_price_value?: number | null
          ebay_item_id?: string | null
          ebay_user_id?: string | null
          estimated_parcel_height?: number | null
          estimated_parcel_length?: number | null
          estimated_parcel_weight?: number | null
          estimated_parcel_width?: number | null
          estimated_shipping_cost?: number | null
          exhibit_date?: string | null
          exhibitor?: string | null
          id?: number
          item_status?: string | null
          item_title?: string | null
          last_synced_at?: string | null
          last_update?: string | null
          listing_status?: string | null
          marketplace_id?: string | null
          primary_image_url?: string | null
          quantity?: number | null
          research_date?: string | null
          researcher?: string | null
          selling_state?: string | null
          sku?: string | null
          status_synced_at?: string | null
          stock_status?: string | null
          stocking_url?: string | null
          title?: string | null
          updated_at?: string | null
          user_id?: number | null
          view_item_url?: string | null
        }
        Update: {
          best_offer_enabled?: boolean | null
          category_id?: string | null
          category_level?: number | null
          category_name?: string | null
          category_path?: string | null
          cost_price?: number | null
          created_at?: string
          current_price_currency?: string | null
          current_price_value?: number | null
          ebay_item_id?: string | null
          ebay_user_id?: string | null
          estimated_parcel_height?: number | null
          estimated_parcel_length?: number | null
          estimated_parcel_weight?: number | null
          estimated_parcel_width?: number | null
          estimated_shipping_cost?: number | null
          exhibit_date?: string | null
          exhibitor?: string | null
          id?: number
          item_status?: string | null
          item_title?: string | null
          last_synced_at?: string | null
          last_update?: string | null
          listing_status?: string | null
          marketplace_id?: string | null
          primary_image_url?: string | null
          quantity?: number | null
          research_date?: string | null
          researcher?: string | null
          selling_state?: string | null
          sku?: string | null
          status_synced_at?: string | null
          stock_status?: string | null
          stocking_url?: string | null
          title?: string | null
          updated_at?: string | null
          user_id?: number | null
          view_item_url?: string | null
        }
        Relationships: []
      }
      markdown_presets: {
        Row: {
          account_id: number
          category_ids: Json
          created_at: string
          description: string | null
          discount_percent: number
          id: number
          is_active: boolean
          price_max: number | null
          price_min: number | null
          title: string
          updated_at: string
        }
        Insert: {
          account_id: number
          category_ids?: Json
          created_at?: string
          description?: string | null
          discount_percent: number
          id?: number
          is_active?: boolean
          price_max?: number | null
          price_min?: number | null
          title: string
          updated_at?: string
        }
        Update: {
          account_id?: number
          category_ids?: Json
          created_at?: string
          description?: string | null
          discount_percent?: number
          id?: number
          is_active?: boolean
          price_max?: number | null
          price_min?: number | null
          title?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "markdown_presets_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "accounts"
            referencedColumns: ["id"]
          },
        ]
      }
      markdown_runs: {
        Row: {
          account_id: number
          error_message: string | null
          executed_at: string
          id: number
          listing_count: number
          preset_id: number | null
          promotion_id: string | null
          request_payload: Json | null
          response_payload: Json | null
          status: string
        }
        Insert: {
          account_id: number
          error_message?: string | null
          executed_at?: string
          id?: number
          listing_count?: number
          preset_id?: number | null
          promotion_id?: string | null
          request_payload?: Json | null
          response_payload?: Json | null
          status: string
        }
        Update: {
          account_id?: number
          error_message?: string | null
          executed_at?: string
          id?: number
          listing_count?: number
          preset_id?: number | null
          promotion_id?: string | null
          request_payload?: Json | null
          response_payload?: Json | null
          status?: string
        }
        Relationships: [
          {
            foreignKeyName: "markdown_runs_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "accounts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "markdown_runs_preset_id_fkey"
            columns: ["preset_id"]
            isOneToOne: false
            referencedRelation: "markdown_presets"
            referencedColumns: ["id"]
          },
        ]
      }
      message_history: {
        Row: {
          body: string
          ebay_buyer_id: string
          id: number
          message_type: string
          sent_at: string
          template_id: number | null
          user_id: number
        }
        Insert: {
          body: string
          ebay_buyer_id: string
          id?: number
          message_type: string
          sent_at?: string
          template_id?: number | null
          user_id: number
        }
        Update: {
          body?: string
          ebay_buyer_id?: string
          id?: number
          message_type?: string
          sent_at?: string
          template_id?: number | null
          user_id?: number
        }
        Relationships: [
          {
            foreignKeyName: "fk_ebay_buyer"
            columns: ["ebay_buyer_id"]
            isOneToOne: false
            referencedRelation: "buyers"
            referencedColumns: ["ebay_buyer_id"]
          },
          {
            foreignKeyName: "template_id_fk"
            columns: ["template_id"]
            isOneToOne: false
            referencedRelation: "message_templates"
            referencedColumns: ["id"]
          },
        ]
      }
      message_templates: {
        Row: {
          body: string
          created_at: string
          id: number
          image_url: string | null
          template_name: string
          updated_at: string
          user_id: number
        }
        Insert: {
          body: string
          created_at?: string
          id?: number
          image_url?: string | null
          template_name: string
          updated_at?: string
          user_id: number
        }
        Update: {
          body?: string
          created_at?: string
          id?: number
          image_url?: string | null
          template_name?: string
          updated_at?: string
          user_id?: number
        }
        Relationships: []
      }
      name_map: {
        Row: {
          created_at: string
          employee_id: string
          id: string
          raw_name: string
          updated_at: string
          user_id: number
        }
        Insert: {
          created_at?: string
          employee_id: string
          id?: string
          raw_name: string
          updated_at?: string
          user_id: number
        }
        Update: {
          created_at?: string
          employee_id?: string
          id?: string
          raw_name?: string
          updated_at?: string
          user_id?: number
        }
        Relationships: [
          {
            foreignKeyName: "name_map_employee_id_fkey"
            columns: ["employee_id"]
            isOneToOne: false
            referencedRelation: "employees"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "name_map_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      octoparse_accounts: {
        Row: {
          access_token: string | null
          access_token_updated_at: string | null
          created_at: string
          expires_in: number | null
          id: number
          password: string | null
          refresh_token: string | null
          refresh_token_updated_at: string | null
          user_id: number | null
          username: string | null
        }
        Insert: {
          access_token?: string | null
          access_token_updated_at?: string | null
          created_at?: string
          expires_in?: number | null
          id?: number
          password?: string | null
          refresh_token?: string | null
          refresh_token_updated_at?: string | null
          user_id?: number | null
          username?: string | null
        }
        Update: {
          access_token?: string | null
          access_token_updated_at?: string | null
          created_at?: string
          expires_in?: number | null
          id?: number
          password?: string | null
          refresh_token?: string | null
          refresh_token_updated_at?: string | null
          user_id?: number | null
          username?: string | null
        }
        Relationships: []
      }
      octoparse_tasks: {
        Row: {
          created_at: string
          ebay_user_id: string | null
          id: string
          task_id: string | null
          task_name: string | null
          updated_at: string | null
          user_id: number
        }
        Insert: {
          created_at?: string
          ebay_user_id?: string | null
          id?: string
          task_id?: string | null
          task_name?: string | null
          updated_at?: string | null
          user_id: number
        }
        Update: {
          created_at?: string
          ebay_user_id?: string | null
          id?: string
          task_id?: string | null
          task_name?: string | null
          updated_at?: string | null
          user_id?: number
        }
        Relationships: []
      }
      openclaw_jobs: {
        Row: {
          completed_at: string | null
          created_at: string
          error_message: string | null
          id: string
          item_id: number
          job_type: string
          payload_json: Json
          result_json: Json | null
          started_at: string | null
          status: string
        }
        Insert: {
          completed_at?: string | null
          created_at?: string
          error_message?: string | null
          id?: string
          item_id: number
          job_type: string
          payload_json: Json
          result_json?: Json | null
          started_at?: string | null
          status?: string
        }
        Update: {
          completed_at?: string | null
          created_at?: string
          error_message?: string | null
          id?: string
          item_id?: number
          job_type?: string
          payload_json?: Json
          result_json?: Json | null
          started_at?: string | null
          status?: string
        }
        Relationships: [
          {
            foreignKeyName: "openclaw_jobs_item_id_fkey"
            columns: ["item_id"]
            isOneToOne: false
            referencedRelation: "baypilot_items"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "openclaw_jobs_item_id_fkey"
            columns: ["item_id"]
            isOneToOne: false
            referencedRelation: "items"
            referencedColumns: ["id"]
          },
        ]
      }
      order_history: {
        Row: {
          buyer_id: number
          created_at: string
          currency: string
          ebay_buyer_id: string
          ebay_user_id: string
          id: number
          order_date: string
          order_id: string
          status: string
          total_amount: number
          updated_at: string
          user_id: number
        }
        Insert: {
          buyer_id: number
          created_at?: string
          currency: string
          ebay_buyer_id: string
          ebay_user_id: string
          id?: number
          order_date: string
          order_id: string
          status: string
          total_amount: number
          updated_at?: string
          user_id: number
        }
        Update: {
          buyer_id?: number
          created_at?: string
          currency?: string
          ebay_buyer_id?: string
          ebay_user_id?: string
          id?: number
          order_date?: string
          order_id?: string
          status?: string
          total_amount?: number
          updated_at?: string
          user_id?: number
        }
        Relationships: [
          {
            foreignKeyName: "buyer_id_fk"
            columns: ["buyer_id"]
            isOneToOne: false
            referencedRelation: "buyers"
            referencedColumns: ["id"]
          },
        ]
      }
      order_line_items: {
        Row: {
          cost_price: number | null
          created_at: string | null
          id: string
          item_image: string | null
          legacy_item_id: string | null
          line_item_cost_currency: string | null
          line_item_cost_value: number | null
          order_no: string
          procurement_ordered_at: string | null
          procurement_site_name: string | null
          procurement_status: string | null
          procurement_tracking_number: string | null
          procurement_url: string | null
          quantity: number | null
          researcher: string | null
          stocking_url: string | null
          title: string | null
          total_currency: string | null
          total_value: number | null
          updated_at: string | null
        }
        Insert: {
          cost_price?: number | null
          created_at?: string | null
          id: string
          item_image?: string | null
          legacy_item_id?: string | null
          line_item_cost_currency?: string | null
          line_item_cost_value?: number | null
          order_no: string
          procurement_ordered_at?: string | null
          procurement_site_name?: string | null
          procurement_status?: string | null
          procurement_tracking_number?: string | null
          procurement_url?: string | null
          quantity?: number | null
          researcher?: string | null
          stocking_url?: string | null
          title?: string | null
          total_currency?: string | null
          total_value?: number | null
          updated_at?: string | null
        }
        Update: {
          cost_price?: number | null
          created_at?: string | null
          id?: string
          item_image?: string | null
          legacy_item_id?: string | null
          line_item_cost_currency?: string | null
          line_item_cost_value?: number | null
          order_no?: string
          procurement_ordered_at?: string | null
          procurement_site_name?: string | null
          procurement_status?: string | null
          procurement_tracking_number?: string | null
          procurement_url?: string | null
          quantity?: number | null
          researcher?: string | null
          stocking_url?: string | null
          title?: string | null
          total_currency?: string | null
          total_value?: number | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "order_line_items_order_no_fkey"
            columns: ["order_no"]
            isOneToOne: false
            referencedRelation: "orders"
            referencedColumns: ["order_no"]
          },
        ]
      }
      orders: {
        Row: {
          bundle_excluded: boolean
          buyer_country_code: string | null
          buyer_id: number | null
          confirming: boolean
          cost_price: number | null
          created_at: string
          damaged: boolean
          delivered_msg_status: string | null
          duty_reconciled_at: string | null
          earnings: number | null
          earnings_after_pl_fee: number | null
          earnings_after_pl_fee_currency: string | null
          earnings_currency: string | null
          ebay_buyer_id: string | null
          ebay_shipment_status: string | null
          ebay_user_id: string | null
          estimated_parcel_height: number | null
          estimated_parcel_length: number | null
          estimated_parcel_weight: number | null
          estimated_parcel_width: number | null
          estimated_shipping_cost: number | null
          final_shipping_cost: number | null
          id: number
          image_url: string | null
          line_items: Json | null
          note: string | null
          notion_url: string | null
          order_date: string | null
          order_no: string | null
          purchase_msg_status: string | null
          researcher: string | null
          ship_to: Json | null
          shipco_parcel_dimension_unit: string | null
          shipco_parcel_height: number | null
          shipco_parcel_length: number | null
          shipco_parcel_weight: number | null
          shipco_parcel_weight_unit: string | null
          shipco_parcel_width: number | null
          shipco_shipping_cost: number | null
          shipco_synced_at: string | null
          shipment_recorded_at: string | null
          shipped_msg_status: string | null
          shipping_carrier: string | null
          shipping_deadline: string | null
          shipping_reconciled_at: string | null
          shipping_status: string | null
          shipping_tracking_number: string | null
          status: string | null
          stocking_status: string | null
          stocking_url: string | null
          subtotal: number | null
          subtotal_currency: string | null
          supplier_link: string | null
          total_amount: number | null
          total_amount_currency: string | null
          user_id: number | null
        }
        Insert: {
          bundle_excluded?: boolean
          buyer_country_code?: string | null
          buyer_id?: number | null
          confirming?: boolean
          cost_price?: number | null
          created_at?: string
          damaged?: boolean
          delivered_msg_status?: string | null
          duty_reconciled_at?: string | null
          earnings?: number | null
          earnings_after_pl_fee?: number | null
          earnings_after_pl_fee_currency?: string | null
          earnings_currency?: string | null
          ebay_buyer_id?: string | null
          ebay_shipment_status?: string | null
          ebay_user_id?: string | null
          estimated_parcel_height?: number | null
          estimated_parcel_length?: number | null
          estimated_parcel_weight?: number | null
          estimated_parcel_width?: number | null
          estimated_shipping_cost?: number | null
          final_shipping_cost?: number | null
          id?: number
          image_url?: string | null
          line_items?: Json | null
          note?: string | null
          notion_url?: string | null
          order_date?: string | null
          order_no?: string | null
          purchase_msg_status?: string | null
          researcher?: string | null
          ship_to?: Json | null
          shipco_parcel_dimension_unit?: string | null
          shipco_parcel_height?: number | null
          shipco_parcel_length?: number | null
          shipco_parcel_weight?: number | null
          shipco_parcel_weight_unit?: string | null
          shipco_parcel_width?: number | null
          shipco_shipping_cost?: number | null
          shipco_synced_at?: string | null
          shipment_recorded_at?: string | null
          shipped_msg_status?: string | null
          shipping_carrier?: string | null
          shipping_deadline?: string | null
          shipping_reconciled_at?: string | null
          shipping_status?: string | null
          shipping_tracking_number?: string | null
          status?: string | null
          stocking_status?: string | null
          stocking_url?: string | null
          subtotal?: number | null
          subtotal_currency?: string | null
          supplier_link?: string | null
          total_amount?: number | null
          total_amount_currency?: string | null
          user_id?: number | null
        }
        Update: {
          bundle_excluded?: boolean
          buyer_country_code?: string | null
          buyer_id?: number | null
          confirming?: boolean
          cost_price?: number | null
          created_at?: string
          damaged?: boolean
          delivered_msg_status?: string | null
          duty_reconciled_at?: string | null
          earnings?: number | null
          earnings_after_pl_fee?: number | null
          earnings_after_pl_fee_currency?: string | null
          earnings_currency?: string | null
          ebay_buyer_id?: string | null
          ebay_shipment_status?: string | null
          ebay_user_id?: string | null
          estimated_parcel_height?: number | null
          estimated_parcel_length?: number | null
          estimated_parcel_weight?: number | null
          estimated_parcel_width?: number | null
          estimated_shipping_cost?: number | null
          final_shipping_cost?: number | null
          id?: number
          image_url?: string | null
          line_items?: Json | null
          note?: string | null
          notion_url?: string | null
          order_date?: string | null
          order_no?: string | null
          purchase_msg_status?: string | null
          researcher?: string | null
          ship_to?: Json | null
          shipco_parcel_dimension_unit?: string | null
          shipco_parcel_height?: number | null
          shipco_parcel_length?: number | null
          shipco_parcel_weight?: number | null
          shipco_parcel_weight_unit?: string | null
          shipco_parcel_width?: number | null
          shipco_shipping_cost?: number | null
          shipco_synced_at?: string | null
          shipment_recorded_at?: string | null
          shipped_msg_status?: string | null
          shipping_carrier?: string | null
          shipping_deadline?: string | null
          shipping_reconciled_at?: string | null
          shipping_status?: string | null
          shipping_tracking_number?: string | null
          status?: string | null
          stocking_status?: string | null
          stocking_url?: string | null
          subtotal?: number | null
          subtotal_currency?: string | null
          supplier_link?: string | null
          total_amount?: number | null
          total_amount_currency?: string | null
          user_id?: number | null
        }
        Relationships: []
      }
      price_change_logs: {
        Row: {
          changed_at: string
          error_message: string | null
          executed_by: string | null
          execution_type: string
          id: string
          item_id: number
          new_price: number
          old_price: number
          openclaw_job_id: string | null
          raw_response: Json | null
          recommendation_id: string | null
          result: string
        }
        Insert: {
          changed_at?: string
          error_message?: string | null
          executed_by?: string | null
          execution_type: string
          id?: string
          item_id: number
          new_price: number
          old_price: number
          openclaw_job_id?: string | null
          raw_response?: Json | null
          recommendation_id?: string | null
          result: string
        }
        Update: {
          changed_at?: string
          error_message?: string | null
          executed_by?: string | null
          execution_type?: string
          id?: string
          item_id?: number
          new_price?: number
          old_price?: number
          openclaw_job_id?: string | null
          raw_response?: Json | null
          recommendation_id?: string | null
          result?: string
        }
        Relationships: [
          {
            foreignKeyName: "price_change_logs_item_id_fkey"
            columns: ["item_id"]
            isOneToOne: false
            referencedRelation: "baypilot_items"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "price_change_logs_item_id_fkey"
            columns: ["item_id"]
            isOneToOne: false
            referencedRelation: "items"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "price_change_logs_openclaw_job_id_fkey"
            columns: ["openclaw_job_id"]
            isOneToOne: false
            referencedRelation: "openclaw_jobs"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "price_change_logs_recommendation_id_fkey"
            columns: ["recommendation_id"]
            isOneToOne: false
            referencedRelation: "price_recommendations"
            referencedColumns: ["id"]
          },
        ]
      }
      price_observations: {
        Row: {
          comp_median_price: number | null
          comp_min_price: number | null
          condition_notes: string | null
          created_at: string
          id: string
          item_id: number
          observed_at: string
          own_price: number
          raw_summary: Json | null
          shipping_notes: string | null
          sold_count_30d: number | null
          sold_median_price: number | null
          sold_min_price: number | null
        }
        Insert: {
          comp_median_price?: number | null
          comp_min_price?: number | null
          condition_notes?: string | null
          created_at?: string
          id?: string
          item_id: number
          observed_at: string
          own_price: number
          raw_summary?: Json | null
          shipping_notes?: string | null
          sold_count_30d?: number | null
          sold_median_price?: number | null
          sold_min_price?: number | null
        }
        Update: {
          comp_median_price?: number | null
          comp_min_price?: number | null
          condition_notes?: string | null
          created_at?: string
          id?: string
          item_id?: number
          observed_at?: string
          own_price?: number
          raw_summary?: Json | null
          shipping_notes?: string | null
          sold_count_30d?: number | null
          sold_median_price?: number | null
          sold_min_price?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "price_observations_item_id_fkey"
            columns: ["item_id"]
            isOneToOne: false
            referencedRelation: "baypilot_items"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "price_observations_item_id_fkey"
            columns: ["item_id"]
            isOneToOne: false
            referencedRelation: "items"
            referencedColumns: ["id"]
          },
        ]
      }
      price_recommendations: {
        Row: {
          action: string
          approved_at: string | null
          approved_by: string | null
          confidence: number
          created_at: string
          current_price: number
          id: string
          item_id: number
          metric_id: string | null
          observation_id: string | null
          reason: string
          recommended_price: number
          rejected_at: string | null
          rejected_by: string | null
          rule_version: string
          status: string
        }
        Insert: {
          action: string
          approved_at?: string | null
          approved_by?: string | null
          confidence: number
          created_at?: string
          current_price: number
          id?: string
          item_id: number
          metric_id?: string | null
          observation_id?: string | null
          reason: string
          recommended_price: number
          rejected_at?: string | null
          rejected_by?: string | null
          rule_version: string
          status?: string
        }
        Update: {
          action?: string
          approved_at?: string | null
          approved_by?: string | null
          confidence?: number
          created_at?: string
          current_price?: number
          id?: string
          item_id?: number
          metric_id?: string | null
          observation_id?: string | null
          reason?: string
          recommended_price?: number
          rejected_at?: string | null
          rejected_by?: string | null
          rule_version?: string
          status?: string
        }
        Relationships: [
          {
            foreignKeyName: "price_recommendations_item_id_fkey"
            columns: ["item_id"]
            isOneToOne: false
            referencedRelation: "baypilot_items"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "price_recommendations_item_id_fkey"
            columns: ["item_id"]
            isOneToOne: false
            referencedRelation: "items"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "price_recommendations_metric_id_fkey"
            columns: ["metric_id"]
            isOneToOne: false
            referencedRelation: "traffic_metrics"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "price_recommendations_observation_id_fkey"
            columns: ["observation_id"]
            isOneToOne: false
            referencedRelation: "price_observations"
            referencedColumns: ["id"]
          },
        ]
      }
      priority_quadrants: {
        Row: {
          created_at: string
          detail: string | null
          due_date: string | null
          id: string
          is_done: boolean
          order_index: number
          quadrant: string
          status: string
          title: string
          updated_at: string
          user_id: number
        }
        Insert: {
          created_at?: string
          detail?: string | null
          due_date?: string | null
          id?: string
          is_done?: boolean
          order_index?: number
          quadrant: string
          status?: string
          title: string
          updated_at?: string
          user_id: number
        }
        Update: {
          created_at?: string
          detail?: string | null
          due_date?: string | null
          id?: string
          is_done?: boolean
          order_index?: number
          quadrant?: string
          status?: string
          title?: string
          updated_at?: string
          user_id?: number
        }
        Relationships: [
          {
            foreignKeyName: "priority_quadrants_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      scoring_rules: {
        Row: {
          active: boolean
          created_at: string
          id: string
          version: string
          weights: Json
        }
        Insert: {
          active?: boolean
          created_at?: string
          id?: string
          version: string
          weights: Json
        }
        Update: {
          active?: boolean
          created_at?: string
          id?: string
          version?: string
          weights?: Json
        }
        Relationships: []
      }
      sheet_conversion_job_items: {
        Row: {
          attempt_count: number
          backend_endpoint: string | null
          created_at: string
          duration_ms: number | null
          finished_at: string | null
          id: number
          job_id: string
          last_error: Json | null
          output_payload: Json | null
          row_index: number
          source_title: string | null
          started_at: string | null
          status: string
          step: string
          updated_at: string
        }
        Insert: {
          attempt_count?: number
          backend_endpoint?: string | null
          created_at?: string
          duration_ms?: number | null
          finished_at?: string | null
          id?: never
          job_id: string
          last_error?: Json | null
          output_payload?: Json | null
          row_index: number
          source_title?: string | null
          started_at?: string | null
          status?: string
          step?: string
          updated_at?: string
        }
        Update: {
          attempt_count?: number
          backend_endpoint?: string | null
          created_at?: string
          duration_ms?: number | null
          finished_at?: string | null
          id?: never
          job_id?: string
          last_error?: Json | null
          output_payload?: Json | null
          row_index?: number
          source_title?: string | null
          started_at?: string | null
          status?: string
          step?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "sheet_conversion_job_items_job_id_fkey"
            columns: ["job_id"]
            isOneToOne: false
            referencedRelation: "sheet_conversion_job_progress"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "sheet_conversion_job_items_job_id_fkey"
            columns: ["job_id"]
            isOneToOne: false
            referencedRelation: "sheet_conversion_jobs"
            referencedColumns: ["id"]
          },
        ]
      }
      sheet_conversion_jobs: {
        Row: {
          completed_at: string | null
          created_at: string
          failed_row_count: number
          id: string
          job_key: string
          last_error: Json | null
          processed_row_count: number
          requested_by: string | null
          settings: Json
          sheet_id: string
          source_row_count: number
          started_at: string | null
          status: string
          stop_reason: string | null
          succeeded_row_count: number
          summary: Json
          updated_at: string
        }
        Insert: {
          completed_at?: string | null
          created_at?: string
          failed_row_count?: number
          id?: string
          job_key: string
          last_error?: Json | null
          processed_row_count?: number
          requested_by?: string | null
          settings?: Json
          sheet_id: string
          source_row_count?: number
          started_at?: string | null
          status?: string
          stop_reason?: string | null
          succeeded_row_count?: number
          summary?: Json
          updated_at?: string
        }
        Update: {
          completed_at?: string | null
          created_at?: string
          failed_row_count?: number
          id?: string
          job_key?: string
          last_error?: Json | null
          processed_row_count?: number
          requested_by?: string | null
          settings?: Json
          sheet_id?: string
          source_row_count?: number
          started_at?: string | null
          status?: string
          stop_reason?: string | null
          succeeded_row_count?: number
          summary?: Json
          updated_at?: string
        }
        Relationships: []
      }
      shipco_senders: {
        Row: {
          address1: string | null
          address2: string | null
          address3: string | null
          city: string | null
          company: string | null
          country: string | null
          created_at: string
          email: string | null
          full_name: string | null
          id: string
          phone: string | null
          province: string | null
          updated_at: string
          user_id: number
          zip: string | null
        }
        Insert: {
          address1?: string | null
          address2?: string | null
          address3?: string | null
          city?: string | null
          company?: string | null
          country?: string | null
          created_at?: string
          email?: string | null
          full_name?: string | null
          id?: string
          phone?: string | null
          province?: string | null
          updated_at?: string
          user_id: number
          zip?: string | null
        }
        Update: {
          address1?: string | null
          address2?: string | null
          address3?: string | null
          city?: string | null
          company?: string | null
          country?: string | null
          created_at?: string
          email?: string | null
          full_name?: string | null
          id?: string
          phone?: string | null
          province?: string | null
          updated_at?: string
          user_id?: number
          zip?: string | null
        }
        Relationships: []
      }
      shipment_group_orders: {
        Row: {
          created_at: string
          group_id: string
          order_no: string
        }
        Insert: {
          created_at?: string
          group_id: string
          order_no: string
        }
        Update: {
          created_at?: string
          group_id?: string
          order_no?: string
        }
        Relationships: [
          {
            foreignKeyName: "shipment_group_orders_group_id_fkey"
            columns: ["group_id"]
            isOneToOne: false
            referencedRelation: "shipment_groups"
            referencedColumns: ["id"]
          },
        ]
      }
      shipment_groups: {
        Row: {
          created_at: string
          id: string
          label_url: string | null
          primary_order_no: string | null
          shipment_id: string | null
          shipped_at: string | null
          shipping_carrier: string | null
          status: string
          tracking_number: string | null
          updated_at: string
          user_id: number
        }
        Insert: {
          created_at?: string
          id?: string
          label_url?: string | null
          primary_order_no?: string | null
          shipment_id?: string | null
          shipped_at?: string | null
          shipping_carrier?: string | null
          status?: string
          tracking_number?: string | null
          updated_at?: string
          user_id: number
        }
        Update: {
          created_at?: string
          id?: string
          label_url?: string | null
          primary_order_no?: string | null
          shipment_id?: string | null
          shipped_at?: string | null
          shipping_carrier?: string | null
          status?: string
          tracking_number?: string | null
          updated_at?: string
          user_id?: number
        }
        Relationships: []
      }
      shipping_rates: {
        Row: {
          carrier: string
          created_at: string
          destination_scope: string
          id: string
          is_active: boolean
          last_synced_at: string | null
          price_yen: number
          service_code: string
          service_name: string | null
          source: string
          updated_at: string
          weight_max_g: number
          zone: number | null
        }
        Insert: {
          carrier: string
          created_at?: string
          destination_scope: string
          id?: string
          is_active?: boolean
          last_synced_at?: string | null
          price_yen: number
          service_code: string
          service_name?: string | null
          source?: string
          updated_at?: string
          weight_max_g: number
          zone?: number | null
        }
        Update: {
          carrier?: string
          created_at?: string
          destination_scope?: string
          id?: string
          is_active?: boolean
          last_synced_at?: string | null
          price_yen?: number
          service_code?: string
          service_name?: string | null
          source?: string
          updated_at?: string
          weight_max_g?: number
          zone?: number | null
        }
        Relationships: []
      }
      system_errors: {
        Row: {
          account_id: number | null
          category: string
          created_at: string
          details: Json | null
          error_code: string
          id: number
          job_id: string | null
          message: string
          order_id: number | null
          payload_summary: Json | null
          provider: string
          request_id: string | null
          retryable: boolean
          severity: string
          user_id: number | null
        }
        Insert: {
          account_id?: number | null
          category: string
          created_at?: string
          details?: Json | null
          error_code: string
          id?: number
          job_id?: string | null
          message: string
          order_id?: number | null
          payload_summary?: Json | null
          provider: string
          request_id?: string | null
          retryable?: boolean
          severity: string
          user_id?: number | null
        }
        Update: {
          account_id?: number | null
          category?: string
          created_at?: string
          details?: Json | null
          error_code?: string
          id?: number
          job_id?: string | null
          message?: string
          order_id?: number | null
          payload_summary?: Json | null
          provider?: string
          request_id?: string | null
          retryable?: boolean
          severity?: string
          user_id?: number | null
        }
        Relationships: []
      }
      test: {
        Row: {
          created_at: string
          id: number
          username: string
        }
        Insert: {
          created_at?: string
          id?: number
          username: string
        }
        Update: {
          created_at?: string
          id?: number
          username?: string
        }
        Relationships: []
      }
      traffic_history: {
        Row: {
          category_id: string | null
          category_name: string | null
          click_through_rate: number | null
          created_at: string | null
          current_promoted_listings_status: string | null
          ebay_item_id: string | null
          ebay_user_id: string | null
          id: number
          item_id: number | null
          listing_title: string | null
          non_search_organic_impressions: number | null
          non_search_promoted_listings_impressions: number | null
          page_views_from_organic_impressions_outside_ebay: number | null
          page_views_via_organic_impressions_on_ebay_site: number | null
          page_views_via_promoted_listings_impressions_from_outside_ebay:
            | number
            | null
          page_views_via_promoted_listings_impressions_on_ebay_site:
            | number
            | null
          percent_change_in_non_search_organic_impressions: number | null
          percent_change_in_non_search_promoted_listings_impressions:
            | number
            | null
          percent_change_in_top_20_search_spot_impressions_from_promoted_:
            | number
            | null
          percent_change_in_top_20_search_spot_organic_impressions:
            | number
            | null
          quantity_available: number | null
          quantity_sold: number | null
          report_month: string | null
          rest_of_search_spot_impressions: number | null
          sales_conversion_rate: number | null
          top_20_search_spot_impressions_from_promoted_listings: number | null
          top_20_search_spot_organic_impressions: number | null
          total_impressions_on_ebay_site: number | null
          total_organic_impressions_on_ebay_site: number | null
          total_page_views: number | null
          total_promoted_listings_impressions: number | null
          user_id: number | null
        }
        Insert: {
          category_id?: string | null
          category_name?: string | null
          click_through_rate?: number | null
          created_at?: string | null
          current_promoted_listings_status?: string | null
          ebay_item_id?: string | null
          ebay_user_id?: string | null
          id?: never
          item_id?: number | null
          listing_title?: string | null
          non_search_organic_impressions?: number | null
          non_search_promoted_listings_impressions?: number | null
          page_views_from_organic_impressions_outside_ebay?: number | null
          page_views_via_organic_impressions_on_ebay_site?: number | null
          page_views_via_promoted_listings_impressions_from_outside_ebay?:
            | number
            | null
          page_views_via_promoted_listings_impressions_on_ebay_site?:
            | number
            | null
          percent_change_in_non_search_organic_impressions?: number | null
          percent_change_in_non_search_promoted_listings_impressions?:
            | number
            | null
          percent_change_in_top_20_search_spot_impressions_from_promoted_?:
            | number
            | null
          percent_change_in_top_20_search_spot_organic_impressions?:
            | number
            | null
          quantity_available?: number | null
          quantity_sold?: number | null
          report_month?: string | null
          rest_of_search_spot_impressions?: number | null
          sales_conversion_rate?: number | null
          top_20_search_spot_impressions_from_promoted_listings?: number | null
          top_20_search_spot_organic_impressions?: number | null
          total_impressions_on_ebay_site?: number | null
          total_organic_impressions_on_ebay_site?: number | null
          total_page_views?: number | null
          total_promoted_listings_impressions?: number | null
          user_id?: number | null
        }
        Update: {
          category_id?: string | null
          category_name?: string | null
          click_through_rate?: number | null
          created_at?: string | null
          current_promoted_listings_status?: string | null
          ebay_item_id?: string | null
          ebay_user_id?: string | null
          id?: never
          item_id?: number | null
          listing_title?: string | null
          non_search_organic_impressions?: number | null
          non_search_promoted_listings_impressions?: number | null
          page_views_from_organic_impressions_outside_ebay?: number | null
          page_views_via_organic_impressions_on_ebay_site?: number | null
          page_views_via_promoted_listings_impressions_from_outside_ebay?:
            | number
            | null
          page_views_via_promoted_listings_impressions_on_ebay_site?:
            | number
            | null
          percent_change_in_non_search_organic_impressions?: number | null
          percent_change_in_non_search_promoted_listings_impressions?:
            | number
            | null
          percent_change_in_top_20_search_spot_impressions_from_promoted_?:
            | number
            | null
          percent_change_in_top_20_search_spot_organic_impressions?:
            | number
            | null
          quantity_available?: number | null
          quantity_sold?: number | null
          report_month?: string | null
          rest_of_search_spot_impressions?: number | null
          sales_conversion_rate?: number | null
          top_20_search_spot_impressions_from_promoted_listings?: number | null
          top_20_search_spot_organic_impressions?: number | null
          total_impressions_on_ebay_site?: number | null
          total_organic_impressions_on_ebay_site?: number | null
          total_page_views?: number | null
          total_promoted_listings_impressions?: number | null
          user_id?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "traffic_history_item_id_fkey"
            columns: ["item_id"]
            isOneToOne: false
            referencedRelation: "baypilot_items"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "traffic_history_item_id_fkey"
            columns: ["item_id"]
            isOneToOne: false
            referencedRelation: "items"
            referencedColumns: ["id"]
          },
        ]
      }
      traffic_metrics: {
        Row: {
          click_through_rate: number | null
          conversion_rate: number | null
          created_at: string
          id: string
          impressions: number | null
          item_id: number
          measured_at: string
          page_views: number | null
          priority_score: number | null
          quantity_sold: number | null
          report_end_date: string | null
          report_start_date: string | null
          watchers: number | null
        }
        Insert: {
          click_through_rate?: number | null
          conversion_rate?: number | null
          created_at?: string
          id?: string
          impressions?: number | null
          item_id: number
          measured_at: string
          page_views?: number | null
          priority_score?: number | null
          quantity_sold?: number | null
          report_end_date?: string | null
          report_start_date?: string | null
          watchers?: number | null
        }
        Update: {
          click_through_rate?: number | null
          conversion_rate?: number | null
          created_at?: string
          id?: string
          impressions?: number | null
          item_id?: number
          measured_at?: string
          page_views?: number | null
          priority_score?: number | null
          quantity_sold?: number | null
          report_end_date?: string | null
          report_start_date?: string | null
          watchers?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "traffic_metrics_item_id_fkey"
            columns: ["item_id"]
            isOneToOne: false
            referencedRelation: "baypilot_items"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "traffic_metrics_item_id_fkey"
            columns: ["item_id"]
            isOneToOne: false
            referencedRelation: "items"
            referencedColumns: ["id"]
          },
        ]
      }
      users: {
        Row: {
          aud_rate: number | null
          cad_rate: number | null
          created_at: string
          email: string | null
          eur_rate: number | null
          gbp_rate: number | null
          id: number
          password: string | null
          usd_rate: number | null
          username: string | null
        }
        Insert: {
          aud_rate?: number | null
          cad_rate?: number | null
          created_at?: string
          email?: string | null
          eur_rate?: number | null
          gbp_rate?: number | null
          id?: number
          password?: string | null
          usd_rate?: number | null
          username?: string | null
        }
        Update: {
          aud_rate?: number | null
          cad_rate?: number | null
          created_at?: string
          email?: string | null
          eur_rate?: number | null
          gbp_rate?: number | null
          id?: number
          password?: string | null
          usd_rate?: number | null
          username?: string | null
        }
        Relationships: []
      }
      webhooks: {
        Row: {
          account_id: number
          created_at: string | null
          event_type: string
          id: number
          is_active: boolean
          url: string
        }
        Insert: {
          account_id: number
          created_at?: string | null
          event_type: string
          id?: number
          is_active?: boolean
          url: string
        }
        Update: {
          account_id?: number
          created_at?: string | null
          event_type?: string
          id?: number
          is_active?: boolean
          url?: string
        }
        Relationships: [
          {
            foreignKeyName: "webhooks_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "accounts"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      baypilot_items: {
        Row: {
          category: string | null
          condition: string | null
          created_at: string | null
          currency: string | null
          current_price: number | null
          ebay_item_id: string | null
          ebay_user_id: string | null
          handling_time: number | null
          id: number | null
          last_price_changed_at: string | null
          sku: string | null
          status: string | null
          title: string | null
          updated_at: string | null
        }
        Insert: {
          category?: string | null
          condition?: never
          created_at?: never
          currency?: never
          current_price?: never
          ebay_item_id?: string | null
          ebay_user_id?: string | null
          handling_time?: never
          id?: number | null
          last_price_changed_at?: never
          sku?: string | null
          status?: never
          title?: never
          updated_at?: never
        }
        Update: {
          category?: string | null
          condition?: never
          created_at?: never
          currency?: never
          current_price?: never
          ebay_item_id?: string | null
          ebay_user_id?: string | null
          handling_time?: never
          id?: number | null
          last_price_changed_at?: never
          sku?: string | null
          status?: never
          title?: never
          updated_at?: never
        }
        Relationships: []
      }
      sheet_conversion_job_progress: {
        Row: {
          completed_at: string | null
          created_at: string | null
          failed_row_count: number | null
          id: string | null
          job_key: string | null
          processed_row_count: number | null
          progress_percent: number | null
          sheet_id: string | null
          source_row_count: number | null
          started_at: string | null
          status: string | null
          succeeded_row_count: number | null
          updated_at: string | null
        }
        Insert: {
          completed_at?: string | null
          created_at?: string | null
          failed_row_count?: number | null
          id?: string | null
          job_key?: string | null
          processed_row_count?: number | null
          progress_percent?: never
          sheet_id?: string | null
          source_row_count?: number | null
          started_at?: string | null
          status?: string | null
          succeeded_row_count?: number | null
          updated_at?: string | null
        }
        Update: {
          completed_at?: string | null
          created_at?: string | null
          failed_row_count?: number | null
          id?: string | null
          job_key?: string | null
          processed_row_count?: number | null
          progress_percent?: never
          sheet_id?: string | null
          source_row_count?: number | null
          started_at?: string | null
          status?: string | null
          succeeded_row_count?: number | null
          updated_at?: string | null
        }
        Relationships: []
      }
      v_carrier_awb_totals: {
        Row: {
          actual_customs_amount: number | null
          actual_fee_amount: number | null
          actual_fee_amount_incl_tax: number | null
          actual_fee_tax_amount: number | null
          actual_shipping_amount: number | null
          actual_total_amount: number | null
          awb_number: string | null
          carrier: string | null
          currency: string | null
          invoice_date: string | null
          invoice_number: string | null
          reference_1: string | null
          shipment_date: string | null
        }
        Relationships: []
      }
    }
    Functions: {
      get_existing_stocking_urls: {
        Args: { p_ebay_user_id: string; p_urls: string[] }
        Returns: {
          stocking_url: string
        }[]
      }
      listings_summary_account_counts: {
        Args: { p_end_date: string; p_start_date: string; p_user_id: number }
        Returns: {
          ebay_user_id: string
          exhibit_count: number
        }[]
      }
      listings_summary_counts: {
        Args: { p_end_date: string; p_start_date: string; p_user_id: number }
        Returns: {
          exhibit_count: number
          research_count: number
          researcher: string
          sales_count: number
        }[]
      }
      show_limit: { Args: never; Returns: number }
      show_trgm: { Args: { "": string }; Returns: string[] }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {},
  },
} as const
