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