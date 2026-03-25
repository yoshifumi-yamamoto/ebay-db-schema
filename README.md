# ebay-db-schema

eBay物販システムで利用している Supabase の `public` schema を一元管理するためのリポジトリです。  
AI（Codex / Claude など）がこのリポジトリを参照することで、DB 構造を推測せず、安全にコード生成・分析できる状態を目指します。

## このリポジトリの目的

- Supabase の DB 構造を一元管理する
- AI（Codex / Claude）が安全に参照できるようにする
- スキーマ変更履歴、型定義、業務ルール、テーブル説明をまとめて管理する

## このリポジトリが管理するもの

- migration（スキーマ変更履歴）
- 型定義
- テーブル構造
- リレーション
- 業務ルール

## ディレクトリ構成

```text
ebay-db-schema/
  README.md
  .gitignore
  .env.example

  supabase/
    migrations/

  types/
    database.types.ts

  docs/
    business-rules.md
    tables.md
    relationships.md
    deletion-candidates.md
    er-notes.md

  scripts/
    pull-schema.sh
    gen-types.sh
    refresh-schema.sh
```

### 各ディレクトリの役割

- `supabase/migrations/`
  - Supabase CLI で pull した migration を保存します。
- `types/`
  - `public` schema から生成した TypeScript 型を保存します。
- `docs/`
  - 業務ルール、テーブル説明、リレーション、削除候補などの補助ドキュメントを保存します。
- `scripts/`
  - スキーマ pull と型生成を安全に実行するためのスクリプトを配置します。

## セットアップ手順

### 1. Supabase CLI をインストール

Supabase CLI を各自の環境にインストールしてください。  
インストール方法は公式ドキュメントを参照してください。

### 2. Supabase にログイン

```bash
supabase login
```

または、CLI 用のアクセストークンを `.env` に `SUPABASE_ACCESS_TOKEN` として設定してください。

### 3. 環境変数を設定

`.env.example` を参考に `.env` を作成し、`SUPABASE_PROJECT_REF` を設定します。  
このリポジトリのスクリプトは `.env` を自動で読み込みます。

```bash
cp .env.example .env
```

### 4. `supabase link` を実行

初回はローカルリポジトリを対象プロジェクトに紐付けるため、`supabase link` を実行してください。

```bash
supabase link --project-ref <your-project-ref>
```

補足:

- `project ref` は Supabase ダッシュボード URL などから確認できます。
- `scripts/pull-schema.sh` は `SUPABASE_PROJECT_REF` を参照します。
- `supabase link` の実行には `supabase login` または `SUPABASE_ACCESS_TOKEN` が必要です。
- 初回 link が済んでいない場合、`db pull` が失敗することがあります。

## スキーマ更新手順

スキーマと型定義をまとめて更新する場合は、以下を実行します。

```bash
./scripts/refresh-schema.sh
```

このスクリプトは以下を順番に実行します。

1. `scripts/pull-schema.sh`
2. `scripts/gen-types.sh`

実行後は必ず `docs/` 配下も見直してください。

## 型定義の更新方法

型定義のみ更新する場合は以下を実行します。

```bash
./scripts/gen-types.sh
```

生成先:

- `types/database.types.ts`

## docs の更新ルール

以下の変更があった場合は、対応する docs を必ず更新してください。

### テーブル追加時

- `docs/tables.md`
- `docs/relationships.md`
- 必要に応じて `docs/business-rules.md`
- 必要に応じて `docs/er-notes.md`

### カラム変更時

- `types/database.types.ts`
- `docs/tables.md`
- 必要に応じて `docs/business-rules.md`
- 必要に応じて `docs/relationships.md`

### ステータス追加時

- `docs/business-rules.md`
- `docs/tables.md` の備考欄
- 実装に影響する場合は `docs/relationships.md` や `docs/er-notes.md`

## 運用ルール

重要: DB 変更時は以下を必ずセットで更新してください。

- migrations
- types
- docs

追加ルール:

- テーブルをいきなり削除しない
- 削除候補は `docs/deletion-candidates.md` に必ず記録する
- 業務ロジックは `docs/business-rules.md` に記載する
- 削除系 SQL はこのリポジトリでは扱わない

## AI 利用時の注意

- この repo を前提にコード生成すること
- DB 構造を推測しないこと
- docs の内容を優先すること
- 型定義だけで判断せず、業務ルールと削除候補管理も確認すること

## scripts 実行例

### `pull-schema.sh`

```bash
./scripts/pull-schema.sh
```

### `gen-types.sh`

```bash
./scripts/gen-types.sh
```

### `refresh-schema.sh`

```bash
./scripts/refresh-schema.sh
```

## 今後の拡張案

- `schema.sql` のスナップショット管理
- ER 図画像の保存
- GitHub Actions で型チェック
- 使用されていないテーブルを検出する SQL の追加
