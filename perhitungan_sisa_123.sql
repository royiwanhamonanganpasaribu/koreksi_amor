 CREATE OR REPLACE VIEW public.perhitungan_sisa_pa_1 AS 
SELECT  "substring"(kredit.akta_krd::text, 7, 1) AS jenis_kredit,
           kredit.id_krd,
            kredit.akta_krd,kredit.typebunga_krd,
            kredit.by_provisi,
            sisa_amor_acc(kredit.id_krd, 'P'::bpchar) AS sisa_provisi,
      kredit.by_adm,
            sisa_amor_acc(kredit.id_krd, 'A'::bpchar) AS sisa_adm 
            
           FROM kredit
          WHERE kredit.active_krd  and "substring"(kredit.akta_krd::text, 7, 1)  = '1'
          ORDER BY kredit.akta_krd ;


CREATE OR REPLACE VIEW public.perhitungan_sisa_mk_1 AS 
SELECT  "substring"(kredit.akta_krd::text, 7, 1) AS jenis_kredit,
           kredit.id_krd,
           
            kredit.akta_krd,kredit.typebunga_krd,
            kredit.mediator_krd,
            sisa_amor_acc(kredit.id_krd, 'M'::bpchar) AS sisa_m,
      kredit.komisi_krd,
            sisa_amor_acc(kredit.id_krd, 'K'::bpchar) AS sisa_k
           FROM kredit
          WHERE kredit.active_krd  and "substring"(kredit.akta_krd::text, 7, 1)  = '1'
          ORDER BY kredit.akta_krd ;


CREATE OR REPLACE VIEW public.perhitungan_sisa_pa_2 AS 
SELECT  "substring"(kredit.akta_krd::text, 7, 1) AS jenis_kredit,
           kredit.id_krd,
            kredit.akta_krd,kredit.typebunga_krd,
            kredit.by_provisi,
            sisa_amor_acc(kredit.id_krd, 'P'::bpchar) AS sisa_provisi,
      kredit.by_adm,
            sisa_amor_acc(kredit.id_krd, 'A'::bpchar) AS sisa_adm 
            
           FROM kredit
          WHERE kredit.active_krd  and "substring"(kredit.akta_krd::text, 7, 1)  = '2'
          ORDER BY kredit.akta_krd ;

CREATE OR REPLACE VIEW public.perhitungan_sisa_mk_2 AS 
SELECT  "substring"(kredit.akta_krd::text, 7, 1) AS jenis_kredit,
           kredit.id_krd,
           
            kredit.akta_krd,kredit.typebunga_krd,
            kredit.mediator_krd,
            sisa_amor_acc(kredit.id_krd, 'M'::bpchar) AS sisa_m,
      kredit.komisi_krd,
            sisa_amor_acc(kredit.id_krd, 'K'::bpchar) AS sisa_k
           FROM kredit
          WHERE kredit.active_krd  and "substring"(kredit.akta_krd::text, 7, 1)  = '2'
          ORDER BY kredit.akta_krd ;


CREATE OR REPLACE VIEW public.perhitungan_sisa_pa_3 AS 
SELECT  "substring"(kredit.akta_krd::text, 7, 1) AS jenis_kredit,
           kredit.id_krd,
            kredit.akta_krd,kredit.typebunga_krd,
            kredit.by_provisi,
            sisa_amor_acc(kredit.id_krd, 'P'::bpchar) AS sisa_provisi,
      kredit.by_adm,
            sisa_amor_acc(kredit.id_krd, 'A'::bpchar) AS sisa_adm 
            
           FROM kredit
          WHERE kredit.active_krd  and "substring"(kredit.akta_krd::text, 7, 1)  = '3'
          ORDER BY kredit.akta_krd ;

CREATE OR REPLACE VIEW public.perhitungan_sisa_mk_3 AS 
SELECT  "substring"(kredit.akta_krd::text, 7, 1) AS jenis_kredit,
           kredit.id_krd,
           
            kredit.akta_krd,kredit.typebunga_krd,
            kredit.mediator_krd,
            sisa_amor_acc(kredit.id_krd, 'M'::bpchar) AS sisa_m,
      kredit.komisi_krd,
            sisa_amor_acc(kredit.id_krd, 'K'::bpchar) AS sisa_k
           FROM kredit
          WHERE kredit.active_krd  and "substring"(kredit.akta_krd::text, 7, 1)  = '3'
          ORDER BY kredit.akta_krd ;