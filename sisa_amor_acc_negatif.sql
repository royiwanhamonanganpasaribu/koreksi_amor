-- View: public.sisa_amor_acc

-- DROP VIEW public.sisa_amor_acc;

CREATE OR REPLACE VIEW public.sisa_amor_acc AS 
 SELECT kredit.id_krd,
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
  ORDER BY kredit.akta_krd;

ALTER TABLE public.sisa_amor_acc
  OWNER TO postgres;

  -- View: public.sisa_amor_acc_negatif

-- DROP VIEW public.sisa_amor_acc_negatif;

CREATE OR REPLACE VIEW public.sisa_amor_acc_negatif AS 
 SELECT sisa_amor_acc.id_krd,
    sisa_amor_acc.akta_krd,
    sisa_amor_acc.by_adm,
    sisa_amor_acc.sisa_adm,
    sisa_amor_acc.by_provisi,
    sisa_amor_acc.sisa_provisi,
    sisa_amor_acc.komisi_krd,
    sisa_amor_acc.sisa_k,
    sisa_amor_acc.mediator_krd,
    sisa_amor_acc.sisa_m
   FROM sisa_amor_acc
  WHERE sisa_amor_acc.sisa_provisi < 0::numeric OR sisa_amor_acc.sisa_k < 0::numeric OR sisa_amor_acc.sisa_m < 0::numeric OR sisa_amor_acc.sisa_adm < 0::numeric
  ORDER BY sisa_amor_acc.akta_krd;

ALTER TABLE public.sisa_amor_acc_negatif
  OWNER TO postgres;
/*
select * from sisa_amor_acc_negatif where id_krd =  23484
or id_krd =   24266
or id_krd =   25636
or id_krd =   25717
or id_krd =   26049
or id_krd =   26199
or id_krd =   26716
or id_krd =   27241
or id_krd =   27638
or id_krd =   27735
or id_krd =   27843
or id_krd =   23430
or id_krd =   24088
or id_krd =   24106
or id_krd =   25443
or id_krd =   25570
or id_krd =   25659
or id_krd =   25735
or id_krd =   25866
or id_krd =   26844
or id_krd =   27121
or id_krd =   27217
or id_krd =   27511
or id_krd =   27763
or id_krd =   27766
or id_krd =   27762
or id_krd =   27770
or id_krd =   27771
or id_krd =   27856
or id_krd =   27974
*/
