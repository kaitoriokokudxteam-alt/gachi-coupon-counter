# ガチクーポンカウンター

MOOV店舗向けカウンターアプリ。ビギナーズクーポン・名刺・お礼DMの配布/戻りをカウントします。
店舗ごとに最大5台のカウンター（枝番）を独立して運用できます。

## セットアップ手順

### 1. Supabaseプロジェクト作成

1. [https://supabase.com](https://supabase.com) にアクセス
2. 「Start your project」からGitHubアカウントでサインアップ
3. 「New project」をクリック
4. 以下を設定:
   - **Organization**: 自分の組織を選択（なければ作成）
   - **Name**: `bird-counter`（任意）
   - **Database Password**: 安全なパスワードを設定（メモしておく）
   - **Region**: `Northeast Asia (Tokyo)` を選択
5. 「Create new project」をクリック（作成に数分かかります）

### 2. テーブル作成

1. Supabaseダッシュボードの左メニューから「SQL Editor」をクリック
2. `supabase-setup.sql` の内容をコピー＆ペースト
3. 「Run」をクリック

### 3. 店舗データ登録

SQL Editorで以下を実行（店舗名は実際のものに変更してください）:

```sql
INSERT INTO stores (name) VALUES
  ('101一宮'),
  ('102港'),
  ('103小牧');
```

### 4. 接続情報の設定

1. Supabaseダッシュボードの左メニュー下部「Project Settings」→「API」
2. 以下の値をコピー:
   - **Project URL** → `https://xxxxx.supabase.co`
   - **anon public** キー → `eyJhbG...`（長い文字列）
3. `index.html` をテキストエディタで開き、以下を書き換え:

```javascript
const SUPABASE_URL = 'YOUR_SUPABASE_URL';        // ← Project URLに変更
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY'; // ← anon keyに変更
```

### 5. 使用開始

- `index.html` をブラウザ（Chrome推奨）で開くだけでOK
- 初回起動時に店舗を選択 → 枝番（カウンター番号）を選択
- 以降は記憶されます
- ブックマークしておくと便利です

## 使い方

- **＋ボタン**: カウントを1増やす
- **−ボタン**: カウントを1減らす（0未満にはならない）
- **店舗名クリック**: 店舗・枝番を変更
- **枝番**: 1店舗で最大5台のレジごとに独立カウント可能
- 営業日は毎朝7:00に自動で切り替わります

## 技術情報

- フロントエンド: HTML + CSS + vanilla JavaScript
- DB: Supabase (PostgreSQL)
- フォント: DotGothic16 (Google Fonts)
- 外部依存: Supabase JS SDK (CDN)
