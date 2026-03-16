-- ===========================================
-- マイグレーション001: 担当者(staff)テーブル追加
-- ===========================================

-- 担当者マスタ（店舗に紐づく）
CREATE TABLE staff (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  barcode TEXT NOT NULL,
  nickname TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE (store_id, barcode)
);

-- RLS設定
ALTER TABLE staff ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow read staff" ON staff
  FOR SELECT USING (true);

CREATE POLICY "Allow insert staff" ON staff
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow update staff" ON staff
  FOR UPDATE USING (true);

CREATE POLICY "Allow delete staff" ON staff
  FOR DELETE USING (true);

-- インデックス
CREATE INDEX idx_staff_store ON staff (store_id);

-- ===========================================
-- countsテーブルにstaff_idカラム追加
-- ===========================================

-- staff_id追加（NULLable: 既存データや担当者未選択時の互換性）
ALTER TABLE counts ADD COLUMN staff_id UUID REFERENCES staff(id) ON DELETE SET NULL;

-- 既存のUNIQUE制約を削除して新しいものに置き換え
ALTER TABLE counts DROP CONSTRAINT counts_store_id_branch_number_business_date_category_key;

-- 新しいUNIQUE制約（staff_idを含む）
-- COALESCE で NULL を統一値に変換してユニーク性を保証
CREATE UNIQUE INDEX idx_counts_unique ON counts (
  store_id, branch_number, business_date, category, COALESCE(staff_id, '00000000-0000-0000-0000-000000000000')
);

-- staff_idのインデックス
CREATE INDEX idx_counts_staff ON counts (staff_id);
