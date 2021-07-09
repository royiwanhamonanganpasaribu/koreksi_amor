
DROP VIEW public.v_kode_cabang_norek_0600_0601;
DROP VIEW public.v_kode_norek_0600_0601;
DROP VIEW public.v_0600_0601_gabungan;
DROP VIEW public.v_0600_0601_uber;
DROP VIEW public.v_0601_uber;
DROP VIEW public.v_0600_uber;
DROP VIEW public.v_0600_0601;
DROP VIEW public.v_0601;
DROP VIEW public.v_0600;
DROP VIEW public.v_lapbul19_gen0600; 
DROP VIEW public.v_lapbul19_gen0600_uber; 
-- View: public.v_lapbul19_gen0600_gol_penjamin

-- DROP VIEW public.v_lapbul19_gen0600_gol_penjamin;

CREATE OR REPLACE VIEW public.v_lapbul19_gen0600_gol_penjamin AS 
SELECT kredit.id_krd,
    kredit.id_jam,
        CASE
            WHEN kredit.id_jam = '2'::bpchar THEN '880'::text
            ELSE '000'::text
        END AS gol_penjamin,
    CASE
            WHEN kredit.id_jam = '2'::bpchar THEN '100.00'::text
            ELSE null
        END AS bag_penjamin
   FROM kredit
     JOIN jaminan USING (id_jam)
  WHERE kredit.active_krd;
ALTER TABLE public.v_lapbul19_gen0600_gol_penjamin
  OWNER TO postgres;

-- View: public.v_lapbul19_gen0600

-- DROP VIEW public.v_lapbul19_gen0600;

CREATE OR REPLACE VIEW public.v_lapbul19_gen0600 AS 
 SELECT DISTINCT kredit.id_krd,
    nasabah.kaitan_nas,
    nasabah.cif2_nas,
    nasabah.ktp_nas,
    reknas.no_rek,
    kredit.biguna_krd,
    kredit.sumber_krd,
    kredit.mulai_krd,
    kredit.akhir_krd,
    kredit.angsur_krd,
    kredit.clt2019_krd AS clt_krd,
    kredit.bungaflat_krd,
    kredit.mulai_macet_krd,
    v_lapbul19_gen0600_pokok.hari_tunggak_pokok,
    v_lapbul19_gen0600_bunga.hari_tunggak_bunga,
    v_lapbul19_gen0600_pokok.nominal_tunggakan_pokok,
    v_lapbul19_gen0600_bunga.nominal_tunggakan_bunga,
    konversi_sektor_ekonomi.lapbul_2019_se,
    kredit.bijenisusaha_krd,
    nasabah.id_dati,
    nasabah.s_bentuk_nas,
    agunan.njop_ag,
    kredit.baki_krd,
    kredit.plafond_krd,
    v_lapbul19_gen0600_pvs_blm_amr.pvs_blm_amr,
    v_lapbul19_gen0600_by_tsk_blm_amr.by_tsk_blm_amr,
    v_lapbul19_gen0600_baki_debet_neto.baki_debet_neto,
    v_lapbul19_gen0600_ppap_yang_dibentuk.ppap_yang_dibentuk,
    v_lapbul19_gen0600_pdpt_bunga_yg_akn_ditrma2.pdpt_bunga_yg_akn_ditrma,
    v_lapbul19_gen0600_pdpt_bunga_dlm_penyelesaian.pdpt_bunga_dlm_penyelesaian,
    v_lapbul19_gen0600_angsuran_pokok_pertama.tgl_pokok_pertama,
    round(qppap2019.ppapwd) AS ppapwd,
    nasabah.s_akta_nas,
    v_lapbul19_gen0600_prd_pembyrn_pk.prd_pembyrn_pk,
    v_lapbul19_gen0600_identitas.identitas,
    kredit.akta_krd,
    v_lapbul19_gen0600_agunan_likuid.agunan_likuid,
    v_lapbul19_gen0600_agunan_non_likuid.diperhitungkan,
    v_lapbul19_gen0600_gol_penjamin.gol_penjamin,
    v_lapbul19_gen0600_gol_penjamin.bag_penjamin
   FROM kredit
     JOIN reknas USING (id_rek)
     JOIN nasabah USING (id_nas)
     JOIN konversi_sektor_ekonomi ON nasabah.sektor_nas = konversi_sektor_ekonomi.bi_se::bpchar
     JOIN agunan_kredit USING (id_krd)
     JOIN agunan USING (id_ag)
     LEFT JOIN lapbul_tunggakan_bunga_kredit USING (id_krd)
     LEFT JOIN lapbul_tunggakan_pokok_kredit USING (id_krd)
     LEFT JOIN lapbul_sisa_ae2 USING (id_krd)
     LEFT JOIN hari_tunggak_bunga USING (id_krd)
     LEFT JOIN hari_tunggak_pokok USING (id_krd)
     LEFT JOIN v_lapbul19_gen0600_pvs_blm_amr USING (id_krd)
     LEFT JOIN v_lapbul19_gen0600_pokok USING (id_krd)
     LEFT JOIN v_lapbul19_gen0600_bunga USING (id_krd)
     LEFT JOIN v_lapbul19_gen0600_by_tsk_blm_amr USING (id_krd)
     LEFT JOIN v_lapbul19_gen0600_baki_debet_neto USING (id_krd)
     LEFT JOIN v_lapbul19_gen0600_ppap_yang_dibentuk USING (id_krd)
     LEFT JOIN v_lapbul19_gen0600_pdpt_bunga_yg_akn_ditrma2 USING (id_krd)
     LEFT JOIN v_lapbul19_gen0600_pdpt_bunga_dlm_penyelesaian USING (id_krd)
     LEFT JOIN v_lapbul19_gen0600_angsuran_pokok_pertama USING (id_krd)
     LEFT JOIN qppap2019 USING (id_krd)
     LEFT JOIN v_lapbul19_gen0600_prd_pembyrn_pk USING (id_krd)
     LEFT JOIN v_lapbul19_gen0600_identitas USING (ktp_nas)
     LEFT JOIN v_lapbul19_gen0600_agunan_likuid USING (id_krd)
     LEFT JOIN v_lapbul19_gen0600_agunan_non_likuid USING (id_krd)
     LEFT JOIN v_lapbul19_gen0600_gol_penjamin USING (id_krd)
  WHERE kredit.active_krd;

ALTER TABLE public.v_lapbul19_gen0600
  OWNER TO postgres;


-- View: public.v_lapbul19_gen0600_uber

-- DROP VIEW public.v_lapbul19_gen0600_uber;

CREATE OR REPLACE VIEW public.v_lapbul19_gen0600_uber AS 
 SELECT uber.id_krd,
    uber.kaitan_nas,
    uber.cif2_nas,
    uber.ktp_nas,
    uber.no_rek,
    uber.biguna_krd,
    uber.sumber_krd,
    uber.mulai_krd,
    uber.akhir_krd,
    uber.angsur_krd,
    uber.clt_krd,
    uber.bungaflat_krd,
    uber.mulai_macet_krd,
    uber.hari_tunggak_pokok,
    uber.hari_tunggak_bunga,
    uber.nominal_tunggakan_pokok,
    uber.nominal_tunggakan_bunga,
    uber.lapbul_2019_se,
    uber.bijenisusaha_krd,
    uber.id_dati,
    uber.s_bentuk_nas,
    uber.njop_ag,
    uber.baki_krd,
    uber.plafond_krd,
    uber.pvs_blm_amr,
    uber.by_tsk_blm_amr,
    uber.baki_debet_neto,
    uber.ppap_yang_dibentuk,
    uber.pdpt_bunga_yg_akn_ditrma,
    uber.pdpt_bunga_dlm_penyelesaian,
    uber.tgl_pokok_pertama,
    uber.ppapwd,
    uber.s_akta_nas,
    uber.prd_pembyrn_pk,
    uber.identitas,
    uber.akta_krd,
    uber.agunan_likuid,
    uber.diperhitungkan,
    uber.gol_penjamin,
    uber.bag_penjamin
   FROM dblink('dbname=uber'::text || npw(), 'select * from v_lapbul19_gen0600'::text) uber(id_krd integer, kaitan_nas character(1), cif2_nas character(16), ktp_nas character varying(60), no_rek character(13), biguna_krd character(2), sumber_krd smallint, mulai_krd date, akhir_krd date, angsur_krd numeric(15,2), clt_krd smallint, bungaflat_krd numeric(7,5), mulai_macet_krd date, hari_tunggak_pokok integer, hari_tunggak_bunga integer, nominal_tunggakan_pokok numeric, nominal_tunggakan_bunga numeric, lapbul_2019_se character varying(6), bijenisusaha_krd smallint, id_dati character(4), s_bentuk_nas character(2), njop_ag numeric(15,0), baki_krd numeric(15,2), plafond_krd numeric(15,2), pvs_blm_amr numeric, by_tsk_blm_amr numeric, baki_debet_neto numeric, ppap_yang_dibentuk numeric, pdpt_bunga_yg_akn_ditrma double precision, pdpt_bunga_dlm_penyelesaian double precision, tgl_pokok_pertama date, ppapwd numeric, s_akta_nas character varying(30), prd_pembyrn_pk integer, identitas character varying, akta_krd character(13), agunan_likuid numeric, diperhitungkan numeric,gol_penjamin text,bag_penjamin text);

ALTER TABLE public.v_lapbul19_gen0600_uber
  OWNER TO postgres;


CREATE OR REPLACE VIEW public.v_0600 AS 
select * FROM v_lapbul19_gen0600;

CREATE OR REPLACE VIEW public.v_0601 AS 
select * FROM v_lapbul19_gen0601;


-- View: public.v_0600_0601

-- DROP VIEW public.v_0600_0601;

CREATE OR REPLACE VIEW public.v_0600_0601 AS 
 SELECT v_0600.id_krd,
    v_0600.kaitan_nas,
    v_0600.cif2_nas,
    v_0600.ktp_nas,
    v_0600.no_rek,
    v_0600.biguna_krd,
    v_0600.sumber_krd,
    v_0600.mulai_krd,
    v_0600.akhir_krd,
    v_0600.angsur_krd,
    v_0600.clt_krd,
    v_0600.bungaflat_krd,
    v_0600.mulai_macet_krd,
    v_0600.hari_tunggak_pokok,
    v_0600.hari_tunggak_bunga,
    v_0600.nominal_tunggakan_pokok,
    v_0600.nominal_tunggakan_bunga,
    v_0600.lapbul_2019_se,
    v_0600.bijenisusaha_krd,
    v_0600.id_dati,
    v_0600.s_bentuk_nas,
    v_0600.njop_ag,
    v_0600.baki_krd,
    v_0600.plafond_krd,
    v_0600.pvs_blm_amr,
    v_0600.by_tsk_blm_amr,
    v_0600.baki_debet_neto,
    v_0600.ppap_yang_dibentuk,
    v_0600.pdpt_bunga_yg_akn_ditrma,
    v_0600.pdpt_bunga_dlm_penyelesaian,
    v_0600.tgl_pokok_pertama,
    v_0600.ppapwd,
    v_0600.s_akta_nas,
    v_0600.prd_pembyrn_pk,
    v_0600.identitas,
    v_0600.agunan_likuid,
    v_0600.diperhitungkan,
    v_0600.gol_penjamin,
    v_0600.bag_penjamin,
    v_0601.id_ag,
    v_0600.akta_krd,
    v_0601.jenis_ag,
    v_0601.alamat_ag,
    v_0601.nilaijamin_krd
   FROM v_0600
     LEFT JOIN v_0601 USING (akta_krd);

ALTER TABLE public.v_0600_0601
  OWNER TO postgres;


CREATE OR REPLACE VIEW public.v_0600_uber AS 
select * FROM v_lapbul19_gen0600_uber;

CREATE OR REPLACE VIEW public.v_0601_uber AS 
select * FROM v_lapbul19_gen0601_uber;

CREATE OR REPLACE VIEW public.v_0600_0601_uber AS 
 SELECT v_0600_uber.id_krd,
    v_0600_uber.kaitan_nas,
    v_0600_uber.cif2_nas,
    v_0600_uber.ktp_nas,
    v_0600_uber.no_rek,
    v_0600_uber.biguna_krd,
    v_0600_uber.sumber_krd,
    v_0600_uber.mulai_krd,
    v_0600_uber.akhir_krd,
    v_0600_uber.angsur_krd,
    v_0600_uber.clt_krd,
    v_0600_uber.bungaflat_krd,
    v_0600_uber.mulai_macet_krd,
    v_0600_uber.hari_tunggak_pokok,
    v_0600_uber.hari_tunggak_bunga,
    v_0600_uber.nominal_tunggakan_pokok,
    v_0600_uber.nominal_tunggakan_bunga,
    v_0600_uber.lapbul_2019_se,
    v_0600_uber.bijenisusaha_krd,
    v_0600_uber.id_dati,
    v_0600_uber.s_bentuk_nas,
    v_0600_uber.njop_ag,
    v_0600_uber.baki_krd,
    v_0600_uber.plafond_krd,
    v_0600_uber.pvs_blm_amr,
    v_0600_uber.by_tsk_blm_amr,
    v_0600_uber.baki_debet_neto,
    v_0600_uber.ppap_yang_dibentuk,
    v_0600_uber.pdpt_bunga_yg_akn_ditrma,
    v_0600_uber.pdpt_bunga_dlm_penyelesaian,
    v_0600_uber.tgl_pokok_pertama,
    v_0600_uber.ppapwd,
    v_0600_uber.s_akta_nas,
    v_0600_uber.prd_pembyrn_pk,
    v_0600_uber.identitas,
    v_0600_uber.agunan_likuid,
    v_0600_uber.diperhitungkan,
    v_0600_uber.gol_penjamin,
    v_0600_uber.bag_penjamin,
   v_0601_uber.id_ag,
    v_0600_uber.akta_krd,
   v_0601_uber.jenis_ag,
   v_0601_uber.alamat_ag,
   v_0601_uber.nilaijamin_krd
   FROM v_0600_uber
     LEFT JOIN v_0601_uber USING (akta_krd);


CREATE OR REPLACE VIEW public.v_0600_0601_gabungan AS 
select *
FROM v_0600_0601
UNION
select * FROM
v_0600_0601_uber;

-- View: public.v_kode_norek_0600_0601

-- DROP VIEW public.v_kode_norek_0600_0601;

CREATE OR REPLACE VIEW public.v_kode_norek_0600_0601 AS 
 SELECT "substring"(v_0600_0601_gabungan.no_rek::text, 1, 6) AS kode_norek_0600_0601,
    v_0600_0601_gabungan.id_krd,
    v_0600_0601_gabungan.kaitan_nas,
    v_0600_0601_gabungan.cif2_nas,
    v_0600_0601_gabungan.ktp_nas,
    v_0600_0601_gabungan.no_rek,
    v_0600_0601_gabungan.biguna_krd,
    v_0600_0601_gabungan.sumber_krd,
    v_0600_0601_gabungan.mulai_krd,
    v_0600_0601_gabungan.akhir_krd,
    v_0600_0601_gabungan.angsur_krd,
    v_0600_0601_gabungan.clt_krd,
    v_0600_0601_gabungan.bungaflat_krd,
    v_0600_0601_gabungan.mulai_macet_krd,
    v_0600_0601_gabungan.hari_tunggak_pokok,
    v_0600_0601_gabungan.hari_tunggak_bunga,
    v_0600_0601_gabungan.nominal_tunggakan_pokok,
    v_0600_0601_gabungan.nominal_tunggakan_bunga,
    v_0600_0601_gabungan.lapbul_2019_se,
    v_0600_0601_gabungan.bijenisusaha_krd,
    v_0600_0601_gabungan.id_dati,
    v_0600_0601_gabungan.s_bentuk_nas,
    v_0600_0601_gabungan.njop_ag,
    v_0600_0601_gabungan.baki_krd,
    v_0600_0601_gabungan.plafond_krd,
    v_0600_0601_gabungan.pvs_blm_amr,
    v_0600_0601_gabungan.by_tsk_blm_amr,
    v_0600_0601_gabungan.baki_debet_neto,
    v_0600_0601_gabungan.ppap_yang_dibentuk,
    v_0600_0601_gabungan.pdpt_bunga_yg_akn_ditrma,
    v_0600_0601_gabungan.pdpt_bunga_dlm_penyelesaian,
    v_0600_0601_gabungan.tgl_pokok_pertama,
    v_0600_0601_gabungan.ppapwd,
    v_0600_0601_gabungan.s_akta_nas,
    v_0600_0601_gabungan.prd_pembyrn_pk,
    v_0600_0601_gabungan.identitas,
    v_0600_0601_gabungan.agunan_likuid,
    v_0600_0601_gabungan.diperhitungkan,
    v_0600_0601_gabungan.id_ag,
    v_0600_0601_gabungan.akta_krd,
    v_0600_0601_gabungan.jenis_ag,
    v_0600_0601_gabungan.alamat_ag,
    v_0600_0601_gabungan.gol_penjamin,
    v_0600_0601_gabungan.bag_penjamin,
    v_0600_0601_gabungan.nilaijamin_krd
   FROM v_0600_0601_gabungan;

ALTER TABLE public.v_kode_norek_0600_0601
  OWNER TO bprdba;

-- View: public.v_kode_cabang_norek_0600_0601

-- DROP VIEW public.v_kode_cabang_norek_0600_0601;

CREATE OR REPLACE VIEW public.v_kode_cabang_norek_0600_0601 AS 
 SELECT v_kode_norek_0600_0601.kode_norek_0600_0601,
    v_kode_norek_0600_0601.id_krd,
    v_kode_norek_0600_0601.kaitan_nas,
    v_kode_norek_0600_0601.cif2_nas,
    v_kode_norek_0600_0601.ktp_nas,
    v_kode_norek_0600_0601.no_rek,
    v_kode_norek_0600_0601.biguna_krd,
    v_kode_norek_0600_0601.sumber_krd,
    v_kode_norek_0600_0601.mulai_krd,
    v_kode_norek_0600_0601.akhir_krd,
    v_kode_norek_0600_0601.angsur_krd,
    v_kode_norek_0600_0601.clt_krd,
    v_kode_norek_0600_0601.bungaflat_krd,
    v_kode_norek_0600_0601.mulai_macet_krd,
    v_kode_norek_0600_0601.hari_tunggak_pokok,
    v_kode_norek_0600_0601.hari_tunggak_bunga,
    v_kode_norek_0600_0601.nominal_tunggakan_pokok,
    v_kode_norek_0600_0601.nominal_tunggakan_bunga,
    v_kode_norek_0600_0601.lapbul_2019_se,
    v_kode_norek_0600_0601.bijenisusaha_krd,
    v_kode_norek_0600_0601.id_dati,
    v_kode_norek_0600_0601.s_bentuk_nas,
    v_kode_norek_0600_0601.njop_ag,
    v_kode_norek_0600_0601.baki_krd,
    v_kode_norek_0600_0601.plafond_krd,
    v_kode_norek_0600_0601.pvs_blm_amr,
    v_kode_norek_0600_0601.by_tsk_blm_amr,
    v_kode_norek_0600_0601.baki_debet_neto,
    v_kode_norek_0600_0601.ppap_yang_dibentuk,
    v_kode_norek_0600_0601.pdpt_bunga_yg_akn_ditrma,
    v_kode_norek_0600_0601.pdpt_bunga_dlm_penyelesaian,
    v_kode_norek_0600_0601.tgl_pokok_pertama,
    v_kode_norek_0600_0601.ppapwd,
    v_kode_norek_0600_0601.s_akta_nas,
    v_kode_norek_0600_0601.prd_pembyrn_pk,
    v_kode_norek_0600_0601.identitas,
    v_kode_norek_0600_0601.agunan_likuid,
    v_kode_norek_0600_0601.diperhitungkan,
    v_kode_norek_0600_0601.id_ag,
    v_kode_norek_0600_0601.akta_krd,
    v_kode_norek_0600_0601.jenis_ag,
    v_kode_norek_0600_0601.alamat_ag,
    v_kode_norek_0600_0601.gol_penjamin,
    v_kode_norek_0600_0601.bag_penjamin,
    v_kode_norek_0600_0601.nilaijamin_krd,
        CASE
            WHEN v_kode_norek_0600_0601.kode_norek_0600_0601 = '1.456.'::text OR v_kode_norek_0600_0601.kode_norek_0600_0601 = '4.456.'::text OR v_kode_norek_0600_0601.kode_norek_0600_0601 = '2.456.'::text OR v_kode_norek_0600_0601.kode_norek_0600_0601 = '3.456.'::text THEN '001'::text
            ELSE '002'::text
        END AS kode_cabang_norek
   FROM v_kode_norek_0600_0601
  ORDER BY (
        CASE
            WHEN v_kode_norek_0600_0601.kode_norek_0600_0601 = '1.456.'::text OR v_kode_norek_0600_0601.kode_norek_0600_0601 = '4.456.'::text OR v_kode_norek_0600_0601.kode_norek_0600_0601 = '2.456.'::text OR v_kode_norek_0600_0601.kode_norek_0600_0601 = '3.456.'::text THEN '001'::text
            ELSE '002'::text
        END);

ALTER TABLE public.v_kode_cabang_norek_0600_0601
  OWNER TO bprdba;

-- Function: public.lapbul19_gen0600()

-- DROP FUNCTION public.lapbul19_gen0600();

CREATE OR REPLACE FUNCTION public.lapbul19_gen0600()
  RETURNS character AS
$BODY$declare
  hasil integer;
  hasil_nilai_agunan_ppap text;
  isi text;
  form  char(4);
  r record;
isi_uber text;
isi_nilai_agunan_ppap text;
  c record; 
begin
  hasil := 0;

  form := '0600';
  isi :=  'H01|010201|601329|' || sekarang() || '|LBBPRK|' || form || '|0|';
--------------------Header---------------------------
  insert into lapbul19 (form_lb, isi_lb) values (form, isi);
 
  for r in select distinct 'D01|001|'::text as depan,id_krd,cif2_nas,ktp_nas,no_rek,biguna_krd,
    sumber_krd,mulai_krd,akhir_krd,angsur_krd,clt_krd,mulai_macet_krd,hari_tunggak_pokok,
    hari_tunggak_bunga,nominal_tunggakan_pokok,nominal_tunggakan_bunga,bijenisusaha_krd,
    id_dati,njop_ag,baki_krd,plafond_krd,pvs_blm_amr,by_tsk_blm_amr,baki_debet_neto,ppap_yang_dibentuk,
    pdpt_bunga_yg_akn_ditrma,pdpt_bunga_dlm_penyelesaian,bungaflat_krd,s_bentuk_nas,kaitan_nas,tgl_pokok_pertama,
    lapbul_2019_se,ppapwd,s_akta_nas,prd_pembyrn_pk,identitas,akta_krd,diperhitungkan,agunan_likuid,gol_penjamin,bag_penjamin
    FROM v_lapbul19_gen0600
    order by akta_krd
    loop 

    isi :=  r.depan    ||   r.cif2_nas || '|' || r.identitas;

    if r.kaitan_nas = 'T' then
      isi := isi || '|Umum|';
    else
      isi := isi || '||';
    end if;
   isi := isi || replace(r.no_rek,'.','') || '|03|' || '10|' 
    || r.biguna_krd ;

    if r.kaitan_nas = 'Y' then
      isi := isi || '|12|';
    else
      isi := isi || '|20|';
    end if;

if r.prd_pembyrn_pk is not null then
    isi := isi  || r.sumber_krd || '|' || r.prd_pembyrn_pk || '|3|' ||  to_char(r.mulai_krd,'yyyyMMdd')  || '|' 
    || to_char(r.akhir_krd,'yyyyMMdd') || '|' || to_char(r.tgl_pokok_pertama,'yyyyMMdd') ||  '|'  || r.clt_krd || '|' ;
   else
    isi := isi  || r.sumber_krd  || '|3|3|' ||  to_char(r.mulai_krd,'yyyyMMdd')  || '|' 
    || to_char(r.akhir_krd,'yyyyMMdd') || '|' || to_char(r.tgl_pokok_pertama,'yyyyMMdd') ||  '|'  || r.clt_krd || '|' ;

end if;

    if r.clt_krd = '5' then
      isi := isi ||  to_char(r.mulai_macet_krd,'yyyyMMdd') || '|'; 
    else
      isi := isi || '|';
    end if;
    if r.hari_tunggak_pokok is not null then
    isi := isi || r.hari_tunggak_pokok || '|';
    else
      isi := isi || '0|';
   end if;
   if r.hari_tunggak_bunga is not null then
    isi := isi || r.hari_tunggak_bunga || '|';
    else
      isi := isi || '0|';
   end if;
    if r.nominal_tunggakan_pokok is not null then
    isi := isi || round(r.nominal_tunggakan_pokok)|| '|';
    else
      isi := isi || '0|';
   end if;
   if r.nominal_tunggakan_bunga is not null then
    isi := isi || round(r.nominal_tunggakan_bunga) || '|';
    else
    isi := isi   || '0|';
   end if;

   if r.s_bentuk_nas is not null then
     isi := isi || '860||';
   else
     isi := isi || '875||';
   end if;

   if r.biguna_krd = '39' and  r.lapbul_2019_se = '011190' or
      r.biguna_krd = '39' and r.lapbul_2019_se >= '003100' or
      r.biguna_krd = '39' and r.lapbul_2019_se <= '009000' then
   isi := isi || '009000' || '|' || r.bijenisusaha_krd || '|';

   else
     if  r.biguna_krd = '10' and r.lapbul_2019_se  >= '001100' and r.lapbul_2019_se <= '011190' or 
         r.biguna_krd = '20' and r.lapbul_2019_se  >= '001100' and r.lapbul_2019_se <= '011190' then
       isi := isi || '930000' || '|' || r.bijenisusaha_krd || '|';
   else
   isi := isi || r.lapbul_2019_se || '|' || r.bijenisusaha_krd || '|';
   end if;
   end if;

   if r.id_dati = '0122' then
      isi = isi ||'0122' || '|' ||  Round(r.bungaflat_krd,2) || '|11|' || r.gol_penjamin;
   else
      isi = isi || r.id_dati  || '|' ||  Round(r.bungaflat_krd,2) || '|11|' || r.gol_penjamin;
   end if;
   
   if r.bag_penjamin is not null then
    isi = isi || '|' || r.bag_penjamin || '|' || Round(r.agunan_likuid) || '|';
   else
    isi = isi || '|' || '|' || Round(r.agunan_likuid) || '|';
   end if;
   isi := isi || Round(r.diperhitungkan);

   isi := isi || '|0|' || Round(r.baki_krd) || '|' || Round(r.plafond_krd)  || '|' || Round(r.plafond_krd) || '|';

   if r.pvs_blm_amr is not null then
     isi := isi || Round(r.pvs_blm_amr) || '|';
   else
     isi := isi   || '0|';
   end if;
   if r.by_tsk_blm_amr is not null then
     isi := isi   || Round(r.by_tsk_blm_amr) || '|';
   else
    isi := isi   || '0|';
   end if;
 isi := isi  || '0||'; 
    if r.baki_debet_neto is not null then
     isi := isi || Round(r.baki_debet_neto) || '|';
   else
     isi := isi   || '0|';
   end if;

    if r.ppapwd is not null then
     isi := isi || Round(r.ppapwd) || '||';
   else
     isi := isi   || '|||';
   end if; 


    if r.pdpt_bunga_yg_akn_ditrma is not null and r.clt_krd >=1 and r.clt_krd <=2   then
       isi := isi   || Round(r.pdpt_bunga_yg_akn_ditrma) || '|' ;
    else
     if r.pdpt_bunga_yg_akn_ditrma is  null and r.clt_krd >=1 and r.clt_krd <=2   then
       isi := isi   ||  '0|' ;
   else
       isi := isi   || '|' ;
   end if; 
   end if; 

    if r.pdpt_bunga_dlm_penyelesaian is not null and r.clt_krd >=3 and r.clt_krd <=5   then
       isi := isi   || Round(r.pdpt_bunga_dlm_penyelesaian) || '|' ;
    else
    if r.pdpt_bunga_dlm_penyelesaian is  null and r.clt_krd >=3 and r.clt_krd <=5   then
       isi := isi   || '0|' ;
   else
       isi := isi   ||  '|';
   end if; 
   end if; 
 

isi := isi || '00';



insert into lapbul19 (form_lb, isi_lb) values (form, isi);
  end loop;
 
 isi_uber := lapbul19_gen0600_uber();
  return hasil;
end;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.lapbul19_gen0600()
  OWNER TO postgres;
COMMENT ON FUNCTION public.lapbul19_gen0600() IS 'fungsi untuk generete lapbul19';

-- Function: public.lapbul19_gen0600_uber()

-- DROP FUNCTION public.lapbul19_gen0600_uber();

CREATE OR REPLACE FUNCTION public.lapbul19_gen0600_uber()
  RETURNS character AS
$BODY$  --------------------Header---------------------------
declare
  hasil integer;
  hasil_nilai_agunan_ppap text;
  isi text;
  form  char(4);
  r record;
isi_uber text;
isi_nilai_agunan_ppap text;
  c record; 
begin
  hasil := 0;

  form := '0600';
 
  for r in select distinct 'D01|002|'::text as depan,id_krd,cif2_nas,ktp_nas,no_rek,biguna_krd,
    sumber_krd,mulai_krd,akhir_krd,angsur_krd,clt_krd,mulai_macet_krd,hari_tunggak_pokok,
    hari_tunggak_bunga,nominal_tunggakan_pokok,nominal_tunggakan_bunga,bijenisusaha_krd,
    id_dati,njop_ag,baki_krd,plafond_krd,pvs_blm_amr,by_tsk_blm_amr,baki_debet_neto,ppap_yang_dibentuk,
    pdpt_bunga_yg_akn_ditrma,pdpt_bunga_dlm_penyelesaian,bungaflat_krd,s_bentuk_nas,kaitan_nas,tgl_pokok_pertama,
     lapbul_2019_se,ppapwd,s_akta_nas,prd_pembyrn_pk,identitas,akta_krd,diperhitungkan,agunan_likuid,gol_penjamin,bag_penjamin
    FROM v_lapbul19_gen0600_uber
    order by akta_krd
    loop 

    isi :=  r.depan    ||   r.cif2_nas || '|' || r.identitas;


    if r.kaitan_nas = 'T' then
      isi := isi || '|Umum|';
    else
      isi := isi || '||';
    end if;
   isi := isi || replace(r.no_rek,'.','') || '|03|' || '10|' 
    || r.biguna_krd ;

    if r.kaitan_nas = 'Y' then
      isi := isi || '|12|';
    else
      isi := isi || '|20|';
    end if;

if r.prd_pembyrn_pk is not null then
    isi := isi  || r.sumber_krd || '|' || r.prd_pembyrn_pk || '|3|' ||  to_char(r.mulai_krd,'yyyyMMdd')  || '|' 
    || to_char(r.akhir_krd,'yyyyMMdd') || '|' || to_char(r.tgl_pokok_pertama,'yyyyMMdd') ||  '|'  || r.clt_krd || '|' ;
   else
    isi := isi  || r.sumber_krd  || '|3|3|' ||  to_char(r.mulai_krd,'yyyyMMdd')  || '|' 
    || to_char(r.akhir_krd,'yyyyMMdd') || '|' || to_char(r.tgl_pokok_pertama,'yyyyMMdd') ||  '|'  || r.clt_krd || '|' ;

end if;

    if r.clt_krd = '5' then
      isi := isi ||  to_char(r.mulai_macet_krd,'yyyyMMdd') || '|'; 
    else
      isi := isi || '|';
    end if;
    if r.hari_tunggak_pokok is not null then
    isi := isi || r.hari_tunggak_pokok || '|';
    else
      isi := isi || '0|';
   end if;
   if r.hari_tunggak_bunga is not null then
    isi := isi || r.hari_tunggak_bunga || '|';
    else
      isi := isi || '0|';
   end if;
    if r.nominal_tunggakan_pokok is not null then
    isi := isi || round(r.nominal_tunggakan_pokok)|| '|';
    else
      isi := isi || '0|';
   end if;
   if r.nominal_tunggakan_bunga is not null then
    isi := isi || round(r.nominal_tunggakan_bunga) || '|';
    else
    isi := isi   || '0|';
   end if;

   if r.s_bentuk_nas is not null then
     isi := isi || '860||';
   else
     isi := isi || '875||';
   end if;

   if r.biguna_krd = '39' and  r.lapbul_2019_se = '011190' or
      r.biguna_krd = '39' and r.lapbul_2019_se >= '003100' or
      r.biguna_krd = '39' and r.lapbul_2019_se <= '009000' then
   isi := isi || '009000' || '|' || r.bijenisusaha_krd || '|';

   else
     if  r.biguna_krd = '10' and r.lapbul_2019_se  >= '001100' and r.lapbul_2019_se <= '011190' or 
         r.biguna_krd = '20' and r.lapbul_2019_se  >= '001100' and r.lapbul_2019_se <= '011190' then
       isi := isi || '930000' || '|' || r.bijenisusaha_krd || '|';
   else
   isi := isi || r.lapbul_2019_se || '|' || r.bijenisusaha_krd || '|';
   end if;
   end if;
 
   if r.id_dati = '0122' then
      isi = isi ||'0122' || '|' ||  Round(r.bungaflat_krd,2) || '|11|' || r.gol_penjamin;
   else
      isi = isi || r.id_dati  || '|' ||  Round(r.bungaflat_krd,2) || '|11|' || r.gol_penjamin;
   end if;
   
   if r.bag_penjamin is not null then
    isi = isi || '|' || r.bag_penjamin || '|' || Round(r.agunan_likuid) || '|';
   else
    isi = isi || '|' || '|' || Round(r.agunan_likuid) || '|';
   end if;
   isi := isi || Round(r.diperhitungkan);

   isi := isi || '|0|' || Round(r.baki_krd) || '|' || Round(r.plafond_krd)  || '|' || Round(r.plafond_krd) || '|';

   if r.pvs_blm_amr is not null then
     isi := isi || Round(r.pvs_blm_amr) || '|';
   else
     isi := isi   || '0|';
   end if;
   if r.by_tsk_blm_amr is not null then
     isi := isi   || Round(r.by_tsk_blm_amr) || '|';
   else
    isi := isi   || '0|';
   end if;
 isi := isi  || '0||'; 
    if r.baki_debet_neto is not null then
     isi := isi || Round(r.baki_debet_neto) || '|';
   else
     isi := isi   || '0|';
   end if;

    if r.ppapwd is not null then
     isi := isi || Round(r.ppapwd) || '||';
   else
     isi := isi   || '|||';
   end if; 


    if r.pdpt_bunga_yg_akn_ditrma is not null and r.clt_krd >=1 and r.clt_krd <=2   then
       isi := isi   || Round(r.pdpt_bunga_yg_akn_ditrma) || '|' ;
    else
     if r.pdpt_bunga_yg_akn_ditrma is  null and r.clt_krd >=1 and r.clt_krd <=2   then
       isi := isi   ||  '0|' ;
   else
       isi := isi   || '|' ;
   end if; 
   end if; 

    if r.pdpt_bunga_dlm_penyelesaian is not null and r.clt_krd >=3 and r.clt_krd <=5   then
       isi := isi   || Round(r.pdpt_bunga_dlm_penyelesaian) || '|' ;
    else
    if r.pdpt_bunga_dlm_penyelesaian is  null and r.clt_krd >=3 and r.clt_krd <=5   then
       isi := isi   || '0|' ;
   else
       isi := isi   ||  '|';
   end if; 
   end if; 
 

isi := isi || '00';



insert into lapbul19 (form_lb, isi_lb) values (form, isi);
  end loop;
  return hasil;
end; -- end of lapbul19_gen1$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.lapbul19_gen0600_uber()
  OWNER TO postgres;
COMMENT ON FUNCTION public.lapbul19_gen0600_uber() IS 'fungsi untuk generete lapbul19';
