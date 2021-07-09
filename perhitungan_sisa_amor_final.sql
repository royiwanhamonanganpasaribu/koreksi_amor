
select in_log('Perihitungan_sisa_amor_final.sql','membandingkan data detail kredit dengan yang ada di tabel coa');
-- View: public.perhitungan_sisa

-- DROP VIEW public.perhitungan_sisa;

CREATE OR REPLACE VIEW public.perhitungan_sisa AS 
 SELECT sisa_amor.jenis_kredit,
    sum(sisa_amor.sisa_adm) AS adm_blm_amor,
    sum(sisa_amor.sisa_provisi) AS provisi_blm_amor,
    sum(sisa_amor.sisa_k) AS komisi_blm_amor,
    sum(sisa_amor.sisa_m) AS mediator_blm_amor
   FROM ( SELECT kredit.id_krd,
            "substring"(kredit.akta_krd::text, 7, 1) AS jenis_kredit,
            kredit.akta_krd,
            kredit.by_adm,
            sisa_amor_acc(kredit.id_krd, 'A'::bpchar) AS sisa_adm,
            kredit.by_provisi,
            sisa_amor_acc(kredit.id_krd, 'P'::bpchar) AS sisa_provisi,
            kredit.komisi_krd,
            sisa_amor_acc(kredit.id_krd, 'K'::bpchar) AS sisa_k,
            kredit.mediator_krd,
            sisa_amor_acc(kredit.id_krd, 'M'::bpchar) AS sisa_m
           FROM kredit
          WHERE kredit.active_krd
          ORDER BY kredit.akta_krd) sisa_amor
  GROUP BY sisa_amor.jenis_kredit
  ORDER BY sisa_amor.jenis_kredit;

ALTER TABLE public.perhitungan_sisa
  OWNER TO postgres;

-- View: public.perhitungan_sisa_mk_inv_0

-- DROP VIEW public.perhitungan_sisa_mk_inv_0;

CREATE OR REPLACE VIEW public.perhitungan_sisa_mk_inv_0 AS 
 SELECT
        CASE
            WHEN perhitungan_sisa.jenis_kredit <> '1'::text OR perhitungan_sisa.jenis_kredit <> '3'::text THEN 2
            ELSE NULL::integer
        END AS jenis_kredit,
        CASE
            WHEN perhitungan_sisa.jenis_kredit = '2'::text THEN sum(perhitungan_sisa.mediator_blm_amor + perhitungan_sisa.komisi_blm_amor)
            WHEN perhitungan_sisa.jenis_kredit <> '1'::text OR perhitungan_sisa.jenis_kredit <> '3'::text THEN '0'::numeric
            ELSE NULL::numeric
        END AS mk_inv
   FROM perhitungan_sisa
  WHERE perhitungan_sisa.jenis_kredit <> '1'::text OR perhitungan_sisa.jenis_kredit <> '3'::text
  GROUP BY perhitungan_sisa.jenis_kredit, perhitungan_sisa.mediator_blm_amor, perhitungan_sisa.komisi_blm_amor;

ALTER TABLE public.perhitungan_sisa_mk_inv_0
  OWNER TO postgres;

-- View: public.perhitungan_sisa_mk_inv

-- DROP VIEW public.perhitungan_sisa_mk_inv;

CREATE OR REPLACE VIEW public.perhitungan_sisa_mk_inv AS 
 SELECT perhitungan_sisa_mk_inv_0.jenis_kredit,
    sum(perhitungan_sisa_mk_inv_0.mk_inv) AS mk_inv
   FROM perhitungan_sisa_mk_inv_0
  GROUP BY perhitungan_sisa_mk_inv_0.jenis_kredit;

ALTER TABLE public.perhitungan_sisa_mk_inv
  OWNER TO postgres;

-- View: public.perhitungan_sisa_mk_ksm

-- DROP VIEW public.perhitungan_sisa_mk_ksm;

CREATE OR REPLACE VIEW public.perhitungan_sisa_mk_ksm AS 
 SELECT perhitungan_sisa.jenis_kredit,
    sum(perhitungan_sisa.mediator_blm_amor + perhitungan_sisa.komisi_blm_amor) AS mk_ksm
   FROM perhitungan_sisa
  WHERE perhitungan_sisa.jenis_kredit = '3'::text
  GROUP BY perhitungan_sisa.jenis_kredit;

ALTER TABLE public.perhitungan_sisa_mk_ksm
  OWNER TO postgres;
-- View: public.perhitungan_sisa_pa_ksm

-- DROP VIEW public.perhitungan_sisa_pa_ksm;

CREATE OR REPLACE VIEW public.perhitungan_sisa_pa_ksm AS 
 SELECT perhitungan_sisa.jenis_kredit,
    sum(perhitungan_sisa.provisi_blm_amor + perhitungan_sisa.adm_blm_amor) AS pa_ksm
   FROM perhitungan_sisa
  WHERE perhitungan_sisa.jenis_kredit = '3'::text
  GROUP BY perhitungan_sisa.jenis_kredit;

ALTER TABLE public.perhitungan_sisa_pa_ksm
  OWNER TO postgres;
-- View: public.perhitungan_sisa_pa_mk

-- DROP VIEW public.perhitungan_sisa_pa_mk;

CREATE OR REPLACE VIEW public.perhitungan_sisa_pa_mk AS 
 SELECT perhitungan_sisa.jenis_kredit,
    sum(perhitungan_sisa.provisi_blm_amor + perhitungan_sisa.adm_blm_amor) AS pa_mk
   FROM perhitungan_sisa
  WHERE perhitungan_sisa.jenis_kredit = '1'::text
  GROUP BY perhitungan_sisa.jenis_kredit;

ALTER TABLE public.perhitungan_sisa_pa_mk
  OWNER TO postgres;
-- View: public.perhitungan_sisa_mk_mk

-- DROP VIEW public.perhitungan_sisa_mk_mk;

CREATE OR REPLACE VIEW public.perhitungan_sisa_mk_mk AS 
 SELECT perhitungan_sisa.jenis_kredit,
    sum(perhitungan_sisa.mediator_blm_amor + perhitungan_sisa.komisi_blm_amor) AS mk_mk
   FROM perhitungan_sisa
  WHERE perhitungan_sisa.jenis_kredit = '1'::text
  GROUP BY perhitungan_sisa.jenis_kredit;

ALTER TABLE public.perhitungan_sisa_mk_mk
  OWNER TO postgres;
  -- View: public.perhitungan_sisa_pa_inv_0

-- DROP VIEW public.perhitungan_sisa_pa_inv_0;

CREATE OR REPLACE VIEW public.perhitungan_sisa_pa_inv_0 AS 
 SELECT
        CASE
            WHEN perhitungan_sisa.jenis_kredit <> '1'::text OR perhitungan_sisa.jenis_kredit <> '3'::text THEN 2
            ELSE NULL::integer
        END AS jenis_kredit,
        CASE
            WHEN perhitungan_sisa.jenis_kredit = '2'::text THEN sum(perhitungan_sisa.provisi_blm_amor + perhitungan_sisa.adm_blm_amor)
            WHEN perhitungan_sisa.jenis_kredit <> '1'::text OR perhitungan_sisa.jenis_kredit <> '3'::text THEN '0'::numeric
            ELSE NULL::numeric
        END AS pa_inv
   FROM perhitungan_sisa
  WHERE perhitungan_sisa.jenis_kredit <> '1'::text OR perhitungan_sisa.jenis_kredit <> '3'::text
  GROUP BY perhitungan_sisa.jenis_kredit, perhitungan_sisa.mediator_blm_amor, perhitungan_sisa.komisi_blm_amor;

ALTER TABLE public.perhitungan_sisa_pa_inv_0
  OWNER TO postgres;

-- View: public.perhitungan_sisa_pa_inv

-- DROP VIEW public.perhitungan_sisa_pa_inv;

CREATE OR REPLACE VIEW public.perhitungan_sisa_pa_inv AS 
 SELECT perhitungan_sisa_pa_inv_0.jenis_kredit,
    sum(perhitungan_sisa_pa_inv_0.pa_inv) AS pa_inv
   FROM perhitungan_sisa_pa_inv_0
  GROUP BY perhitungan_sisa_pa_inv_0.jenis_kredit;

ALTER TABLE public.perhitungan_sisa_pa_inv
  OWNER TO postgres;


-- View: public.perhitungan_sisa_amor_final

-- DROP VIEW public.perhitungan_sisa_amor_final;

CREATE OR REPLACE VIEW public.perhitungan_sisa_amor_final AS 
 SELECT sekarang() AS sekarang,
    perhitungan_sisa_pa_mk.pa_mk,
    perhitungan_sisa_mk_mk.mk_mk,
    perhitungan_sisa_pa_inv.pa_inv,
    perhitungan_sisa_mk_inv.mk_inv,
    perhitungan_sisa_pa_ksm.pa_ksm,
    perhitungan_sisa_mk_ksm.mk_ksm,
    coa_13011.coa_13011,
    coa_13012.coa_13012,
    coa_13021.coa_13021,
    coa_13031.coa_13031,
    coa_13022.coa_13022,
    coa_13032.coa_13032,
    coa_16001.coa_16001,
    deposito_k.komisi_dep
   FROM perhitungan_sisa_pa_mk,
    perhitungan_sisa_mk_mk,
    perhitungan_sisa_pa_inv,
    perhitungan_sisa_mk_inv,
    perhitungan_sisa_pa_ksm,
    perhitungan_sisa_mk_ksm,
    coa_13011,
    coa_13012,
    coa_13021,
    coa_13031,
    coa_13022,
    coa_13032,
    coa_16001,
    deposito_k;

ALTER TABLE public.perhitungan_sisa_amor_final
  OWNER TO postgres;
