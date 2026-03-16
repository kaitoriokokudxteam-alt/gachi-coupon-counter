-- =============================================
-- 違算報告テーブル
-- =============================================

-- 違算用店舗マスタ
CREATE TABLE IF NOT EXISTS discrepancy_stores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_code TEXT NOT NULL UNIQUE,
  store_name TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- 違算報告データ
CREATE TABLE IF NOT EXISTS discrepancy_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_code TEXT NOT NULL,
  store_name TEXT NOT NULL,
  reporter TEXT NOT NULL,
  business_date DATE NOT NULL,
  amount INTEGER NOT NULL,
  reason TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- インデックス
CREATE INDEX IF NOT EXISTS idx_discrepancy_reports_date ON discrepancy_reports(business_date);
CREATE INDEX IF NOT EXISTS idx_discrepancy_reports_store ON discrepancy_reports(store_code);
CREATE INDEX IF NOT EXISTS idx_discrepancy_stores_code ON discrepancy_stores(store_code);

-- RLSを有効化
ALTER TABLE discrepancy_stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE discrepancy_reports ENABLE ROW LEVEL SECURITY;

-- anonキーでの全操作を許可
CREATE POLICY "discrepancy_stores_all" ON discrepancy_stores FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "discrepancy_reports_all" ON discrepancy_reports FOR ALL USING (true) WITH CHECK (true);
