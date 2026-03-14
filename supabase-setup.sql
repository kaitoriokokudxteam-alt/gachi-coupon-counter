-- ===========================================
-- バードカウンター Supabase セットアップSQL
-- ===========================================

-- 店舗マスタ
CREATE TABLE stores (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- カウントデータ
CREATE TABLE counts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  store_id UUID NOT NULL REFERENCES stores(id),
  business_date DATE NOT NULL,
  category TEXT NOT NULL CHECK (category IN (
    'beginners_coupon_out',
    'beginners_coupon_return',
    'meishi_out',
    'meishi_return',
    'thanks_dm_out',
    'thanks_dm_return'
  )),
  count INTEGER NOT NULL DEFAULT 0 CHECK (count >= 0),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE (store_id, business_date, category)
);

-- updated_at 自動更新トリガー
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER counts_updated_at
  BEFORE UPDATE ON counts
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- RLS (Row Level Security) 設定
-- anon キーでの読み書きを許可
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE counts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow read stores" ON stores
  FOR SELECT USING (true);

CREATE POLICY "Allow read counts" ON counts
  FOR SELECT USING (true);

CREATE POLICY "Allow insert counts" ON counts
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow update counts" ON counts
  FOR UPDATE USING (true);

-- インデックス
CREATE INDEX idx_counts_store_date ON counts (store_id, business_date);

-- ===========================================
-- サンプル店舗データ（必要に応じて変更してください）
-- ===========================================
-- INSERT INTO stores (name) VALUES
--   ('渋谷店'),
--   ('新宿店'),
--   ('池袋店');
