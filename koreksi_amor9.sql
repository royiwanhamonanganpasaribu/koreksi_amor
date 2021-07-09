
select in_log('koreksi_amor9.sql','Perubahan di amor_etap');

ALTER TABLE public.trans_amor
    ADD CONSTRAINT id_ae_id_djr_unik UNIQUE (id_ae, id_djr);

CREATE OR REPLACE FUNCTION public.generate_trans_amor(IN coa integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    VOLATILE
    PARALLEL UNSAFE
    COST 100
AS $BODY$declare
  hasil integer;
  djr record;
  amortype text;
  krd integer;
  ae integer;
  depan text;
  depan2 text;
  depan3 text;

begin
  hasil := 0;
  for djr in  select id_djr, ket_djr,debet_djr,kredit_djr from jurnal_detil where id_coa = coa
    --limit 100
  loop
    krd := string2id_krd(djr.ket_djr,'/3.',1,13,'');
  depan := substring(djr.ket_djr,0,6);
  amortype := null;
  if krd is not null then
    case depan
      when 'Adm K' then 
      amortype := 'A';
      when 'Provi' then 
      amortype := 'P';
    when 'Fee M' then
      amortype := 'M';
    when 'Komis' then
      amortype := 'K';
    when 'Penga' then
      depan2 = substring(djr.ket_djr,11,12);
      case depan2
        when 'Pendapatan P' then
        amortype := 'P';
      when 'Pendapatan A' then
        amortype := 'A';
      when 'Biaya Komisi' then
        depan3 = substring(djr.ket_djr,11,21);
        if depan3 = 'Biaya Komisi Mediator' then
          amortype := 'M';
        else
          amortype := 'K';
        end if;
      when 'Biaya Mediat' then
        amortype := 'M';
      else 
        -- do nothing
      end case; -- depan2
    when 'Amort' then
      depan2 := substring(djr.ket_djr,12,3);
      case depan2
        when 'Pro' then
        amortype := 'P';
      when 'Adm' then
        amortype := 'A';
      when 'Kom' then
        amortype := 'K';
      when 'Med' then
        amortype := 'M';
      else
        -- do nothing
      end case; -- depan2
    else
      -- do nothing
    end case; -- depan
  else
    krd := string2id_krd(djr.ket_djr,'Akta ',5,7,'3.456.');
    depan := substring(djr.ket_djr,0,6);
    amortype := null;
      if krd is not null then
      case depan
        when 'Adm K' then 
        amortype := 'A';
        when 'Provi' then 
        amortype := 'P';
      when 'Fee M' then
        amortype := 'M';
      when 'Komis' then
        amortype := 'K';
      when 'Penga' then
        depan2 = substring(djr.ket_djr,11,12);
        case depan2
          when 'Pendapatan P' then
          amortype := 'P';
        when 'Pendapatan A' then
          amortype := 'A';
        when 'Biaya Komisi' then
          depan3 = substring(djr.ket_djr,11,21);
          if depan3 = 'Biaya Komisi Mediator' then
            amortype := 'M';
          else
            amortype := 'K';
          end if;
        when 'Biaya Mediat' then
          amortype := 'M';
        else
          -- do nothing
        end case;
      when 'Amort' then
        depan2 = substring(djr.ket_djr,11,4);
        case depan2
          when 'Pro' then
          amortype := 'P';
        when 'Adm' then
          amortype := 'A';
        when 'Kom' then
          amortype := 'K';
        when 'Med' then
          amortype := 'M';
        else
          -- do nothing
        end case;
      else
        -- do nothing
      end case;
    end if; -- krd is not null (2)
  end if; -- krd is not null (1) /3.
  if krd is not null and amortype is not null then
    select into ae id_ae from amor_etap where id_krd = krd and id_je = amortype;
    if (ae is not null) then
      insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (ae,djr.id_djr,djr.debet_djr,djr.kredit_djr);
    hasil := hasil + 1;
    end if;
  end if;
  end loop;
  return hasil;
end;$BODY$;
  
CREATE OR REPLACE FUNCTION public.amr_id_krd(IN st text)
    RETURNS integer
    LANGUAGE 'plpgsql'
    VOLATILE
    PARALLEL UNSAFE
    COST 100
AS $BODY$declare
  hasil integer;
  krd integer;
  r record;
  
begin
  krd = string2id_krd(st,'/3.',1,13,'');
  if krd is null then
    krd = string2id_krd(st,'Akta ',5,7,'3.456.');
  end if;
  return krd;
end;$BODY$;

ALTER FUNCTION public.amr_id_krd(text)
    OWNER TO postgres;

COMMENT ON FUNCTION public.amr_id_krd(text)
    IS 'mencari id_krd dari keterangan';
  
CREATE OR REPLACE VIEW public.amor_info
 AS
 select id_ae,id_je,id_krd,id_djr 
 from amor_etap join trans_amor using (id_ae);

ALTER TABLE public.amor_info
    OWNER TO postgres;

CREATE OR REPLACE VIEW public.amor_list1
 AS
 select id_ae,entry_op_xdep,id_djr, tgl_djr,id_coa, no_coa,nama_coa
   , ket_djr, debet_djr, kredit_djr
   , id_je,id_krd
   , id_jr,bukti_jr,ket_jr ,tglbuku_jr
   ,amr_id_krd(ket_djr) as krd1
   from jurnal_detil join coa using (id_coa) join transjr using(id_jr)
   left join amor_info using(id_djr)
   where tgl_djr >= '2020-1-1' 
   and (id_coa = 500 or id_coa=501 or id_coa=503 or id_coa=504 or id_coa=505 or id_coa=506)
   order by id_ae desc ,tgl_djr desc;

ALTER TABLE public.amor_list1
    OWNER TO postgres;
  
CREATE OR REPLACE VIEW public.amr_kredit_adm
 AS
select id_krd,id_coa,sum(debet_djr) as debet,sum(kredit_djr) as kredit, nilai_ae,amor_ae,sisa_ae
   from kredit join amor_etap using (id_krd)
     join trans_amor using (id_ae)
   join jurnal_detil using (id_djr)
   where  id_je = 'A'
   group by id_krd,id_coa,nilai_ae,amor_ae,sisa_ae
   order by id_krd;  ;

ALTER TABLE public.amr_kredit_adm
    OWNER TO postgres;
  
CREATE OR REPLACE VIEW public.amr_kredit_prv
 AS
select id_krd,id_coa,sum(debet_djr) as debet,sum(kredit_djr) as kredit, nilai_ae,amor_ae,sisa_ae
   from kredit join amor_etap using (id_krd)
     join trans_amor using (id_ae)
   join jurnal_detil using (id_djr)
   where  id_je = 'P'
   group by id_krd,id_coa,nilai_ae,amor_ae,sisa_ae
   order by id_krd  ;

ALTER TABLE public.amr_kredit_prv
    OWNER TO postgres;  
  
CREATE OR REPLACE VIEW public.amr_kredit_komisi
 AS
select id_krd,id_coa,sum(debet_djr) as debet,sum(kredit_djr) as kredit, nilai_ae,amor_ae,sisa_ae
   from kredit join amor_etap using (id_krd)
     join trans_amor using (id_ae)
   join jurnal_detil using (id_djr)
   where  id_je = 'K'
   group by id_krd,id_coa,nilai_ae,amor_ae,sisa_ae
   order by id_krd ;

ALTER TABLE public.amr_kredit_komisi
    OWNER TO postgres;
  
CREATE OR REPLACE VIEW public.amr_kredit_mediator
 AS
 select id_krd,id_coa,sum(debet_djr) as debet,sum(kredit_djr) as kredit, nilai_ae,amor_ae,sisa_ae
   from kredit join amor_etap using (id_krd)
     join trans_amor using (id_ae)
   join jurnal_detil using (id_djr)
   where  id_je = 'M'
   group by id_krd,id_coa,nilai_ae,amor_ae,sisa_ae
   order by id_krd ;

ALTER TABLE public.amr_kredit_mediator
    OWNER TO postgres;  
  
CREATE OR REPLACE VIEW public.amr_adm1
 AS
select id_krd, akta_krd,typebunga_krd, mulai_krd,active_krd,bln_krd,akhir_krd
  ,tgl_lunas_krd,by_adm,id_coa,debet, kredit, nilai_ae,amor_ae,sisa_ae
  from kredit left join amr_kredit_adm using(id_krd)
  where akhir_krd >= '2020-1-1' and (tgl_lunas_krd >= '2020-1-1' or tgl_lunas_krd is null )
    and not (not active_krd and tgl_lunas_krd is null)
  order by mulai_krd desc;

ALTER TABLE public.amr_adm1
    OWNER TO postgres;

CREATE OR REPLACE VIEW public.amr_komisi1
 AS
SELECT kredit.id_krd,
    kredit.akta_krd,
    kredit.typebunga_krd,
    kredit.mulai_krd,
    kredit.active_krd,
    kredit.bln_krd,
    kredit.akhir_krd,
    kredit.tgl_lunas_krd,
    kredit.komisi_krd,
    kredit.tgl_komisi_krd,
    amr_kredit_mediator.id_coa,
    amr_kredit_mediator.debet,
    amr_kredit_mediator.kredit,
    amr_kredit_mediator.nilai_ae,
    amr_kredit_mediator.amor_ae,
    amr_kredit_mediator.sisa_ae
  
   FROM kredit
     LEFT JOIN amr_kredit_mediator USING (id_krd)
  WHERE kredit.akhir_krd >= '2020-01-01'::date AND (kredit.tgl_lunas_krd >= '2020-01-01'::date OR kredit.tgl_lunas_krd IS NULL) AND NOT (NOT kredit.active_krd AND kredit.tgl_lunas_krd IS NULL) AND kredit.komisi_krd > 0::numeric
  ORDER BY kredit.mulai_krd DESC;

ALTER TABLE public.amr_komisi1
    OWNER TO postgres;

CREATE OR REPLACE VIEW public.amr_mediator1
    AS
     SELECT kredit.id_krd,
    kredit.akta_krd,
    kredit.typebunga_krd,
    kredit.mulai_krd,
    kredit.active_krd,
    kredit.bln_krd,
    kredit.akhir_krd,
    kredit.tgl_lunas_krd,
    kredit.mediator_krd,
    kredit.tgl_mediator_krd,
    amr_kredit_mediator.id_coa,
    amr_kredit_mediator.debet,
    amr_kredit_mediator.kredit,
    amr_kredit_mediator.nilai_ae,
    amr_kredit_mediator.amor_ae,
    amr_kredit_mediator.sisa_ae
  
   FROM kredit
     LEFT JOIN amr_kredit_mediator USING (id_krd)
  WHERE kredit.akhir_krd >= '2020-01-01'::date AND (kredit.tgl_lunas_krd >= '2020-01-01'::date OR kredit.tgl_lunas_krd IS NULL) AND NOT (NOT kredit.active_krd AND kredit.tgl_lunas_krd IS NULL) AND kredit.mediator_krd > 0::numeric
  ORDER BY kredit.mulai_krd DESC;
  
CREATE OR REPLACE VIEW public.amr_adm1
    AS
     SELECT kredit.id_krd,
    kredit.akta_krd,
    kredit.typebunga_krd,
    kredit.mulai_krd,
    kredit.active_krd,
    kredit.bln_krd,
    kredit.akhir_krd,
    kredit.tgl_lunas_krd,
    kredit.by_adm,
    amr_kredit_adm.id_coa,
    amr_kredit_adm.debet,
    amr_kredit_adm.kredit,
    amr_kredit_adm.nilai_ae,
    amr_kredit_adm.amor_ae,
    amr_kredit_adm.sisa_ae
   FROM kredit
     LEFT JOIN amr_kredit_adm USING (id_krd)
  WHERE by_adm > 0 and kredit.akhir_krd >= '2020-01-01'::date AND (kredit.tgl_lunas_krd >= '2020-01-01'::date OR kredit.tgl_lunas_krd IS NULL) AND NOT (NOT kredit.active_krd AND kredit.tgl_lunas_krd IS NULL)
  ORDER BY kredit.mulai_krd DESC; 

CREATE OR REPLACE VIEW public.amr_provisi1
 AS
SELECT kredit.id_krd,
    kredit.akta_krd,
    kredit.typebunga_krd,
    kredit.mulai_krd,
    kredit.active_krd,
    kredit.bln_krd,
    kredit.akhir_krd,
    kredit.tgl_lunas_krd,
    kredit.by_provisi,
    amr_kredit_prv.id_coa,
    amr_kredit_prv.debet,
    amr_kredit_prv.kredit,
    amr_kredit_prv.nilai_ae,
    amr_kredit_prv.amor_ae,
    amr_kredit_prv.sisa_ae
   FROM kredit
     LEFT JOIN amr_kredit_prv USING (id_krd)
  WHERE by_provisi > 0 and kredit.akhir_krd >= '2020-01-01'::date AND (kredit.tgl_lunas_krd >= '2020-01-01'::date OR kredit.tgl_lunas_krd IS NULL) AND NOT (NOT kredit.active_krd AND kredit.tgl_lunas_krd IS NULL)
  ORDER BY kredit.mulai_krd DESC;

ALTER TABLE public.amr_provisi1
    OWNER TO postgres;

DROP VIEW public.amr_komisi1;
CREATE OR REPLACE VIEW public.amr_komisi1
    AS
    SELECT kredit.id_krd,
    kredit.akta_krd,
    kredit.typebunga_krd,
    kredit.mulai_krd,
    kredit.active_krd,
    kredit.bln_krd,
    kredit.akhir_krd,
    kredit.tgl_lunas_krd,
    kredit.komisi_krd,
    kredit.tgl_komisi_krd,
    amr_kredit_komisi.id_coa,
    amr_kredit_komisi.debet,
    amr_kredit_komisi.kredit,
    amr_kredit_komisi.nilai_ae,
    amr_kredit_komisi.amor_ae,
    amr_kredit_komisi.sisa_ae
   FROM kredit
     LEFT JOIN amr_kredit_komisi USING (id_krd)
  WHERE kredit.akhir_krd >= '2020-01-01'::date AND (kredit.tgl_lunas_krd >= '2020-01-01'::date OR kredit.tgl_lunas_krd IS NULL) AND NOT (NOT kredit.active_krd AND kredit.tgl_lunas_krd IS NULL) AND kredit.komisi_krd > 0::numeric
  ORDER BY kredit.mulai_krd DESC;
COMMENT ON VIEW public.amr_komisi1
    IS '';

CREATE OR REPLACE FUNCTION public.string2id_krd(IN st character varying,IN header character varying,IN fr integer,IN lg integer,IN prefix character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    VOLATILE
    PARALLEL UNSAFE
    COST 100
AS $BODY$declare
  hasil integer;
  posisi integer;
  akta text;
  krd record;

begin
  posisi = position(header in st);
  akta = prefix || substring(st from posisi+fr for lg);
  for krd in select * from kredit where akta_krd = akta
  loop
    if krd.active_krd then
    hasil := krd.id_krd;
  else
    if (krd.tgl_lunas_krd is not null) then
      hasil := krd.id_krd;
    end if;
  end if; -- krd_active
  end loop;
  return hasil;
end;$BODY$;

ALTER TABLE public.jurnal_detil
    ADD COLUMN note_djr text;

COMMENT ON COLUMN public.jurnal_detil.note_djr
    IS 'Keterangan (optional) untuk penelusuran umum. Dibuat pada saat penelurusan amor.';

CREATE OR REPLACE VIEW public.amor_list2
 AS
  SELECT amor_info.id_ae,
    jurnal_detil.entry_op_xdep,
    jurnal_detil.id_djr,
    jurnal_detil.tgl_djr,
    jurnal_detil.id_coa,
    coa.no_coa,
    coa.nama_coa,
    jurnal_detil.ket_djr,
    jurnal_detil.debet_djr,
    jurnal_detil.kredit_djr,
    amor_info.id_je,
    amor_info.id_krd,
    jurnal_detil.id_jr,
    transjr.bukti_jr,
    transjr.ket_jr,
    transjr.tglbuku_jr,
    amr_id_krd(jurnal_detil.ket_djr::text) AS krd1,
  note_djr
   FROM jurnal_detil
     JOIN coa USING (id_coa)
     JOIN transjr USING (id_jr)
     LEFT JOIN amor_info USING (id_djr)
  WHERE jurnal_detil.tgl_djr >= '2020-01-01'::date AND (jurnal_detil.id_coa = 500 OR jurnal_detil.id_coa = 501 OR jurnal_detil.id_coa = 503 OR jurnal_detil.id_coa = 504 OR jurnal_detil.id_coa = 505 OR jurnal_detil.id_coa = 506)
  ORDER BY amor_info.id_ae DESC, jurnal_detil.tgl_djr DESC;

ALTER TABLE public.amor_list2
    OWNER TO postgres;


 
 
 --------------------------- PART 2
 select in_log('koreksi_amor6.sql', 'Part 2. Koreksi Amor. Generate nilai amor di pencairan. Generate final amor terakhir di pelunasan. Fungsi sisa_amor. Menghalangi perubahan di komisi_krd dan mediator_krd jika sudah terisi. Generate jurnal_detil secara otomatis pada saat aktivasi (termasuk komisi dan mediator jika diisi). Mengubah rekening perantara menjadi 128.00 (muncul di jurnal detil pada saat mengisi komisi / mediator., Perubahan di tambah_xkrd nonul(rk.komisi_krd)');

CREATE FUNCTION public.sisa_amor_acc(IN krd integer, IN jenis character)
    RETURNS numeric
    LANGUAGE 'plpgsql'
    
AS $BODY$-- menghasilkan sisa amor untuk krd (id_krd) dan jenis (id_je) yang dimasukan
-- ditentukan menurut penelusuran di jurnal_detil
declare
  r record;
  hasil numeric(15,2);
begin
  hasil := 0;
  if jenis = 'A' or jenis = 'P' then
    select into hasil 
      sum(kredit_djr) - sum(debet_djr)  
      from jurnal_detil join trans_amor using (id_djr) join amor_etap using (id_ae)
      where id_krd = krd and id_je=jenis;
   elsif jenis = 'K' or jenis = 'M' then
     select into hasil 
      sum(debet_djr) - sum(kredit_djr)   
      from jurnal_detil join trans_amor using (id_djr) join amor_etap using (id_ae)
      where id_krd = krd and id_je=jenis;
   else
     hasil = 0;
   end if;
  return nonul(hasil);
end;$BODY$;

ALTER FUNCTION public.sisa_amor_acc(integer, character)
    OWNER TO postgres;

COMMENT ON FUNCTION public.sisa_amor_acc(integer, character)
    IS 'Menghasilkan sisa amor untuk id_krd, id_je yang dimasukan.';
  
CREATE OR REPLACE FUNCTION public.aktivasi_kredit()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    VOLATILE
    COST 100
AS $BODY$declare
  d character(1);
  r record;
  j record;
  tbl record;
  tbl2 record;
  tbl3 record;

begin
-- kalo kredit diactivate baru generate segala macem
  if new.active_krd = true and old.active_krd = false then
-- blok deposito
    if new.id_jam ='3' then
      for r in select * from listjam where id_krd = new.id_krd loop
        update deposito set blocked_dep = true where id_dep = r.id_dep;
      end loop;
    end if;

  -- insert di trans_kredit kalo
    insert into trans_kredit (
         id_krd,id_sandi,tgl_xkrd,salp_xkrd,salb_xkrd,proses_xkrd,
         pokokt_xkrd, bungat_xkrd, penalty_xkrd
    ) values (
         new.id_krd,'30',new.mulai_krd,new.pinjaman_krd,new.bunga_krd,true,
         new.pinjaman_krd,new.bunga_krd, new.by_adm
    );

   -- update saldo di reknas
    update reknas set sldtab_rek = new.pinjaman_krd+new.bunga_krd 
      where id_rek = new.id_rek;

    -- dropping kredit ke tabungan
    insert into trans_tab
      (id_rek,id_sandi,tgl_xtab,bkt_xtab,k_xtab,d_xtab,
       del_xtab, proses_xtab,printed_xtab,prs_xtab)
       values
      (new.ambildari_krd,'30',sekarang()::date,'KR '||substring(new.akta_krd from '.....$'),new.pinjaman_krd,0,
       false, true,false,true);

    if new.typebunga_krd = 'A' then
      insert into trans_tab
        (id_rek,id_sandi,tgl_xtab,bkt_xtab,k_xtab,d_xtab,
         del_xtab, proses_xtab,printed_xtab,prs_xtab)
         values
        (new.ambildari_krd,'10',sekarang()::date,'KR '||substring(new.akta_krd from '.....$'),0,new.angsur_krd,
         false, true,false,true);
    end if;

    insert into trans_tab
      (id_rek,id_sandi,tgl_xtab,bkt_xtab,k_xtab,d_xtab,
       del_xtab, proses_xtab,printed_xtab,prs_xtab)
       values
      (new.ambildari_krd,'14',sekarang()::date,'KR '||substring(new.akta_krd from '.....$'),0,new.by_adm+new.by_asuransi+new.by_provisi+new.fidusia_krd,
       false, true,false,true);
    d:=edge(new.id_krd);

-- penanganan amortisasi ETAP
-- generate adm & provisi di amor_etap -- delete 200519 karena koreksi amor. Insert into amor_etap pindah ke tambah_xkrd di id_sandi = 30
/*
    select into j * from jenis_etap where id_je = 'A';
    if new.pinjaman_krd > j.batas_je then
      insert into amor_etap
      (id_je,id_krd,nilai_ae,reset)
      values
      ('A',new.id_krd,new.by_adm,false);
    end if;
    select into j * from jenis_etap where id_je = 'P';
    if new.pinjaman_krd > j.batas_je then
      insert into amor_etap
      (id_je,id_krd,nilai_ae,reset)
      values
      ('P',new.id_krd,new.by_provisi,false);
    end if;
*/ 

-- generate komisi (kalo ada). Biasanya komisi belum di input. Komisi akan digenerate di ubahkrd
-- delete 200519 karena koreksi amor. Insert into amor_etap pindah ke tambah_xkrd di id_sandi = 30
/*
    select into j * from jenis_etap where id_je = 'P';
    if new.pinjaman_krd > j.batas_je then
      if new.komisi_krd is not null then
        insert into amor_etap
          (id_je,id_krd,nilai_ae,reset)
          values
          ('K',old.id_krd,old.komisi_krd,false);
      end if;
    end if;
*/
--syntak dibawah ini digunakan untuk mengupdate operation di tabel nasabah ketika kredit nsabah tsbt menjadi aktif(KEBUTUHAN PELAPORAN SID)

    select into tbl sidoperation_nas from nasabah,kredit,reknas where nasabah.id_nas=reknas.id_nas and reknas.no_rek=kredit.akta_krd and kredit.akta_krd =old.akta_krd;
    select into tbl2 satu_nas from nasabah,kredit,reknas where nasabah.id_nas=reknas.id_nas and reknas.no_rek=kredit.akta_krd and kredit.akta_krd =old.akta_krd;
    if tbl.sidoperation_nas='C' then
  if tbl2.satu_nas is not null then
    select into tbl3 sidoperation_nas from nasabah where nasabah.id_nas=tbl2.satu_nas;
    --jika nasabah tsbt adalah nasabah gabungan,maka operation satu_nasnya harus dicek karena di sid maupun temporary ,data yg dikirim-->
    --untuk pelaporan kredit sid adalah satu nas nya,maka dari itu perlu dicek seperti ini agar tidak rangkap datanya masuk temporary

     if tbl3.sidoperation_nas='C' then
    UPDATE nasabah SET sidoperation_nas ='A' FROM kredit JOIN reknas ON (kredit.akta_krd =reknas.no_rek) WHERE kredit.akta_krd =old.akta_krd and reknas.id_nas=nasabah.id_nas and nasabah.sidoperation_nas='C';
    UPDATE kredit SET sidoperation_krd ='A'  where kredit.akta_krd=old.akta_krd;
    UPDATE reknas SET sidoperation_rek ='A' FROM kredit WHERE kredit.akta_krd =reknas.no_rek and kredit.akta_krd =old.akta_krd ;
     else
    UPDATE reknas SET sidoperation_rek ='A' FROM kredit WHERE kredit.akta_krd =reknas.no_rek and kredit.akta_krd =old.akta_krd ;
    UPDATE kredit SET sidoperation_krd ='A'  where kredit.akta_krd=old.akta_krd;
     end if;
  else
    UPDATE nasabah SET sidoperation_nas ='A' FROM kredit JOIN reknas ON (kredit.akta_krd =reknas.no_rek) WHERE kredit.akta_krd =old.akta_krd and reknas.id_nas=nasabah.id_nas and nasabah.sidoperation_nas='C';
    UPDATE kredit SET sidoperation_krd ='A'  where kredit.akta_krd=old.akta_krd;
    UPDATE reknas SET sidoperation_rek ='A' FROM kredit WHERE kredit.akta_krd =reknas.no_rek and kredit.akta_krd =old.akta_krd ;
  end if;
      else
  if tbl.sidoperation_nas<>'C' then
    UPDATE reknas SET sidoperation_rek ='A' FROM kredit WHERE kredit.akta_krd =reknas.no_rek and kredit.akta_krd =old.akta_krd ;
    UPDATE kredit SET sidoperation_krd ='A'  where kredit.akta_krd=old.akta_krd;
  end if;
      end if;
-- end of syntak SID
  elsif new.active_krd = true and old.active_krd = false then
-- buka blok deposito
    if new.id_jam ='3' then
      for r in select * from listjam where id_krd = new.id_krd loop
        update deposito set blocked_dep = false where id_dep = r.id_dep;
      end loop;
    end if;
  end if;
  return new;
end;$BODY$; 
  


CREATE OR REPLACE FUNCTION public.sisa_amor_acc(IN krd integer,IN jenis character)
    RETURNS numeric
    LANGUAGE 'plpgsql'
    VOLATILE
    PARALLEL UNSAFE
    COST 100
AS $BODY$-- menghasilkan sisa amor untuk krd (id_krd) dan jenis (id_je) yang dimasukan
-- ditentukan menurut penelusuran di jurnal_detil
declare
  r record;
  hasil numeric(15,2);
begin
  hasil := 0;
  if jenis = 'A' or jenis = 'P' then
    select into hasil 
      sum(kredit_xa) - sum(debet_xa)  
      from trans_amor join amor_etap using (id_ae)
      where id_krd = krd and id_je=jenis;
   elsif jenis = 'K' or jenis = 'M' then
     select into hasil 
      sum(debet_xa) - sum(kredit_xa)   
      from trans_amor join amor_etap using (id_ae)
      where id_krd = krd and id_je=jenis;
   else
     hasil = 0;
   end if;
  return nonul(hasil);
end;$BODY$;


CREATE OR REPLACE FUNCTION public.generate_trans_amor(IN coa integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    VOLATILE
    PARALLEL UNSAFE
    COST 100
AS $BODY$declare
  hasil integer;
  djr record;
  amortype text;
  krd integer;
  ae integer;
  depan text;
  depan2 text;
  depan3 text;
 
begin
  hasil := 0;
  for djr in  select id_djr, ket_djr,debet_djr,kredit_djr from jurnal_detil 
    where id_coa = coa and id_djr not in (select id_djr from trans_amor)
    --limit 100
  loop
    krd := string2id_krd(djr.ket_djr,'/3.',1,13,'');
  depan := substring(djr.ket_djr,0,6);
  amortype := null;
  if krd is not null then
    case depan
      when 'Adm K' then 
      amortype := 'A';
      when 'Provi' then 
      amortype := 'P';
    when 'Fee M' then
      amortype := 'M';
    when 'Komis' then
      amortype := 'K';
    when 'Penga' then
      depan2 = substring(djr.ket_djr,11,12);
      case depan2
        when 'Pendapatan P' then
        amortype := 'P';
      when 'Pendapatan A' then
        amortype := 'A';
      when 'Biaya Komisi' then
        depan3 = substring(djr.ket_djr,11,21);
        if depan3 = 'Biaya Komisi Mediator' then
          amortype := 'M';
        else
          amortype := 'K';
        end if;
      when 'Biaya Mediat' then
        amortype := 'M';
      else 
        -- do nothing
      end case; -- depan2
    when 'Amort' then
      depan2 := substring(djr.ket_djr,12,3);
      case depan2
        when 'Pro' then
        amortype := 'P';
      when 'Adm' then
        amortype := 'A';
      when 'Kom' then
        amortype := 'K';
      when 'Med' then
        amortype := 'M';
      else
        -- do nothing
      end case; -- depan2
    else
      -- do nothing
    end case; -- depan
  else
    krd := string2id_krd(djr.ket_djr,'Akta ',5,7,'3.456.');
    depan := substring(djr.ket_djr,0,6);
    amortype := null;
      if krd is not null then
      case depan
        when 'Adm K' then 
        amortype := 'A';
        when 'Provi' then 
        amortype := 'P';
      when 'Fee M' then
        amortype := 'M';
      when 'Komis' then
        amortype := 'K';
      when 'Penga' then
        depan2 = substring(djr.ket_djr,11,12);
        case depan2
          when 'Pendapatan P' then
          amortype := 'P';
        when 'Pendapatan A' then
          amortype := 'A';
        when 'Biaya Komisi' then
          depan3 = substring(djr.ket_djr,11,21);
          if depan3 = 'Biaya Komisi Mediator' then
            amortype := 'M';
          else
            amortype := 'K';
          end if;
        when 'Biaya Mediat' then
          amortype := 'M';
        else
          -- do nothing
        end case;
      when 'Amort' then
        depan2 = substring(djr.ket_djr,11,4);
        case depan2
          when 'Pro' then
          amortype := 'P';
        when 'Adm' then
          amortype := 'A';
        when 'Kom' then
          amortype := 'K';
        when 'Med' then
          amortype := 'M';
        else
          -- do nothing
        end case;
      else
        -- do nothing
      end case;
    end if; -- krd is not null (2)
  end if; -- krd is not null (1) /3.
  if krd is not null and amortype is not null then
    select into ae id_ae from amor_etap where id_krd = krd and id_je = amortype;
    if (ae is not null) then
      insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (ae,djr.id_djr,djr.debet_djr,djr.kredit_djr);
    hasil := hasil + 1;
    end if;
  end if;
  end loop;
  return hasil;
end;$BODY$;
 
 CREATE OR REPLACE FUNCTION public.tambah_xkrd()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    VOLATILE
    COST 100
AS $BODY$-- 11 jan 08 accrue
-- 30 okt 07 tambah_xkrd
-- 25 jan koreksi nomor akta akta_kredit()
-- 19 mei 2020 koreksi amor

declare
  p record;
  kode char(2);
  xjr int4;
  k numeric(15,2);
  d numeric(15,2);
  nocoa int4;
  nocoa2 int4;
  kr record;
  d2 numeric(15,2);
  norektab character(13);
  kt character(100);
  rk record;
  kt2 text;
  nilai numeric(15,2);
  nilai_amor numeric(15,2);
  skr date;
  bkt character(10);
  a record;
  j record;
  ka text;
  akta text;
  sadm text;
  sprov text;
  jedbt int4;
  jekrd int4;
  iddebet int4;
  idkredit int4;
  idae int4;
  
-- dari OB-Sheet
  baki numeric(15,0);
  bg numeric(15,0);
-- selesai dari OB-Sheet

begin
  skr := sekarang();
  new.tgl_lunas_pokok_xkrd := new.tglproses_xkrd;
  if new.proses_xkrd = true then
    -- ubah outstanding di kredit
    if new.id_sandi = '38' or new.id_sandi = '39' then /* hapus buku & hapus tagih */
     -- tidak perlu edit kredit lagi supaya tidak recursive, karena di ubah_kredit panggil tambah_xkrd
     -- perlu generate transaksi proses
    else
      update kredit set 
        baki_krd=baki_krd+new.pokokt_xkrd-new.pokokk_xkrd, 
        osbunga_krd=osbunga_krd+new.bungat_xkrd-new.bungak_xkrd
        where id_krd = new.id_krd;
    end if;
    -- generate transaksi keuangan
    if new.id_sandi = '36' then /* pelunasan kredit */
      update kredit set active_krd = false where id_krd = new.id_krd;
      select into rk * from kredit join reknas using (id_rek)
                                   join nasabah using (id_nas)
                                   join (select id_krd, max(tgl_xkrd) as maxdate from trans_kredit 
                                           where lunas_xkrd = '1'  
                                           group by id_krd) as xkrd
                                      using (id_krd)
                       where id_krd = new.id_krd;
      kt:=rk.akta_krd;
      select akta_krd into akta  from kredit where id_krd = new.id_krd;

      if akta is null then
        akta := ' ';
      end if;
      kode:=new.id_sandi;
      insert into transjr
        (id_com,tglbuku_jr,ket_jr,
         asal_jr,kegiatan_id,acc_jr
        )
       values
        ('1',skr::date,'Pelunasan Kredit', 
         'K',new.id_xkrd,true
        );
      select into xjr currval('public.transjr_id_jr_seq');
      select into bkt bukti_jr from transjr where id_jr = xjr;
      new.bkt_xkrd = bkt ;
      kt := ' Kredit Akta '||akta_kredit(new.id_krd);
      select into kr * from kredit where id_krd = new.id_krd;
      select into norektab no_rek from reknas, kredit  
         where reknas.id_rek = kredit.ambildari_krd and id_krd = new.id_krd;
      select into nocoa id_coa from coa where no_coa = '20001';
      insert into jurnal_detil
           (id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr,id_sandi
           )
           values
           (xjr,sekarang(),nocoa,
            nonul(new.pokokk_xkrd)+nonul(new.bungak_xkrd)+nonul(new.penalty_xkrd)-
            nonul(new.discbng_xkrd)+nonul(new.denda_xkrd),
            0,substring(norektab||' Pelunasan'||kt from 1 for 100),true,'14'
           );

      if kr.biguna_krd ='10' then
        select into nocoa id_coa from coa where no_coa = '13010';
      elsif kr.biguna_krd = '20' then
        select into nocoa id_coa from coa where no_coa = '13020';
      else
        select into nocoa id_coa from coa where no_coa = '13030';
      end if;
      insert into jurnal_detil
         (id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr)
         values
         (xjr,sekarang(),nocoa,0,new.pokokk_xkrd,'POKOK'||kt,true);
      if new.penalty_xkrd <> 0 then
         select into nocoa id_coa from coa where no_coa = '37025';
         insert into jurnal_detil
           (id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr)
           values
           (xjr,sekarang(),nocoa,0,new.penalty_xkrd,'Penalty'||kt,true);
      end if;

      if date_part('year',skr)*100+date_part('mon',skr) > date_part('year',rk.maxdate)*100+date_part('mon',rk.maxdate) then
        if date_part('d',rk.mulai_krd) >= 30 then
          nilai := 0;
        else
          nilai := round((30-date_part('d',rk.mulai_krd))*new.salp_xkrd*kr.bungaef_krd/36000);
        end if; 
      else
        nilai := 0;
      end if; -- date_part
      nilai := nonul(new.accrue_xkrd);
      if nilai <> 0 then
        select into nocoa id_coa from coa where no_coa = '14000';
        insert into jurnal_detil
          (id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr)
          values
          (xjr,skr,nocoa,0,nilai,'Bunga'||kt,true);
      end if;
      if nonul(new.bungak_xkrd) - nilai - nonul(new.discbng_xkrd) <> 0 then
        select into nocoa id_coa from coa where no_coa = '30001';
        insert into jurnal_detil
          (id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr)
          values
          (xjr,skr,nocoa,0,nonul(new.bungak_xkrd) - nilai - nonul(new.discbng_xkrd),'Bunga'||kt,true);
      end if;
      if new.denda_xkrd <> 0 then
        select into nocoa id_coa from coa where no_coa = '30020';
        insert into jurnal_detil
        (id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr)
        values
        (xjr,sekarang(),nocoa,0,new.denda_xkrd,'Denda'||kt,true);
      end if;
      
	  -- jurnal amortisasi etap
      insert into transjr
        (id_com,tglbuku_jr,ket_jr,asal_jr,kegiatan_id,acc_jr)
        values
        ('1',skr::date,'Amor Lunas '||akta,'K',new.id_xkrd,true);
      select into xjr currval('public.transjr_id_jr_seq');
      select into bkt bukti_jr from transjr where id_jr = xjr;
      for a in select sisa_amor_acc(id_krd,id_je) as sisa, amor_etap.*, kredit.akta_krd  -- koreksi_amor1 200519
        from amor_etap join kredit using(id_krd)
        where id_krd = new.id_krd and sisa_ae > 0 
        order by id_je 
	  loop
	    if a.sisa <> 0 then                                                              -- koreksi_amor1 200519
          select * into j from jenis_etap where id_je = a.id_je;
          if a.id_je = 'A' then
            ka := 'Pengakuan Pendapatan Adm '||kt;
			nilai_amor := a.sisa;
          elsif a.id_je = 'P' then
            ka := 'Pengakuan Pendapatan Provisi '||kt;
			nilai_amor := a.sisa;
          elsif a.id_je = 'M' then
            ka := 'Pengakuan Biaya Mediator '||kt;
			if a.sisa >= 0 then        
			  nilai_amor := a.sisa;
			else
			  nilai_amor := nonul(rk.mediator_krd) + a.sisa;            -- anggap bahwa debet biaya mediator sudah dilakukan dengan benar
			end if;
          else
            ka := 'Pengakuan Biaya Komisi '||kt;
			if a.sisa >= 0 then        
			  nilai_amor := a.sisa;
			else
			  nilai_amor := nonul(rk.komisi_krd) + a.sisa;            -- anggap bahwa debet biaya komisi sudah dilakukan dengan benar
			end if;
          end if;
			
          if substr(a.akta_krd,7,1) ='1' then
            jedbt := j.d1_je;
            jekrd := j.k1_je;
          elseif substr(a.akta_krd,7,1) ='2' then
            jedbt := j.d2_je;
            jekrd := j.k2_je;   
          else
            jedbt := j.d3_je;
            jekrd := j.k3_je;
          end if;

          iddebet := nextval('jurnal_detil_id_djr_seq');                       -- koreksi_amor1 200519
          insert into jurnal_detil
            (id_jr,id_djr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr)
            values
            (xjr,iddebet,sekarang(),jedbt,nilai_amor,0,ka,true);
			
		  idkredit := nextval('jurnal_detil_id_djr_seq');                      -- koreksi_amor1 200519
          insert into jurnal_detil
            (id_jr,id_djr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr)
            values
            (xjr,idkredit,sekarang(),jekrd,0,nilai_amor,ka,true);  
			
		  if a.id_je = 'A' or a.id_je='P' then                                 -- koreksi_amor1 200519
		    insert into trans_amor (id_ae,id_djr,debet_xa) values (a.id_ae,iddebet,nilai_amor);    -- insert di trans_amor
		  else
		    insert into trans_amor (id_ae,id_djr,kredit_xa) values (a.id_ae,idkredit,nilai_amor);
		  end if; -- a.id_je
		  
	    end if; -- a.sisa <> 0
      end loop;
	  update amor_etap set sisa_ae = 0 where id_krd = new.id_krd;                       -- koreksi_amor1 200519
    -- dari OB-SHeet
    elsif new.id_sandi = '33'  then            -- angsuran kredit hapus buku / tagih. Tidak perlu generate jurnal 
      select into kr * from kredit where id_krd = new.id_krd;
      baki := kr.baki_krd - nonul(new.pokokk_xkrd);
      if baki < 0 then baki :=0; end if;
      bg := kr.osbunga_krd - nonul(new.bungak_xkrd);
      if bg < 0 then bg :=0; end if;
      if baki = 0 and bg = 0 then
        update kredit set baki_krd = baki, osbunga_krd = bg, tgl_hapus_krd = null, tgl_hapus_tagih_krd = null
          where id_krd = new.id_krd;
      else
        update kredit set baki_krd = baki, osbunga_krd = bg
          where id_krd = new.id_krd;
      end if;
    -- selesai OB-Sheet
    -- 37 = cicilan pertama in advance, sudah ditangani manual, jadi tidak perlu di generate  
	-- koreksi untuk id_sandi 37 2020-05-18. Manual tidak menangani amor id_sandi 37 (A), harus di generate oleh system
    elsif new.id_sandi <> '37'  then
      select into rk * from kredit join reknas using (id_rek)
                                   join nasabah using (id_nas)
                       where id_krd = new.id_krd;
--      select into kt akta_krd from kredit where id_krd = new.id_krd;
      kt:=rk.akta_krd;
      kode:=new.id_sandi;
      if new.id_sandi = '38' or new.id_sandi = '39' then
        -- tidak perlu generate transjr , karena dibukukan manual
      else
        insert into transjr
          (id_com,tglbuku_jr,ket_jr,bukti_jr,
           asal_jr,kegiatan_id,acc_jr,id_jr
          )
         values
          ('1',sekarang()::date,'Kredit', 'KR '||kanan(5::int2,kt),
           'K',new.id_xkrd,true,nextval('public.transjr_id_jr_seq')
          );
        select into xjr currval('public.transjr_id_jr_seq');
      end if;
      
       if new.id_sandi = '30' then /* proses khusus pencairan kredit */
         kt := '/'||rk.akta_krd||'/'||rk.nama_nas;
         select into kr * from kredit where id_krd = new.id_krd;
         if kr.biguna_krd = '10' then
           select into nocoa id_coa from coa where no_coa = '13010';
         elsif kr.biguna_krd = '20' then
           select into nocoa id_coa from coa where no_coa = '13020';
         else
           select into nocoa id_coa from coa where no_coa = '13030';
         end if;
         insert into jurnal_detil
           (id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr
           )
           values
           (xjr,sekarang(),nocoa,kr.pinjaman_krd,0,'POKOK'||kt,true
           );
         if kr.by_adm > 0 then                                                           -- koreksi_amor1 200519
		   select into j * from jenis_etap where id_je = 'A';
           if kr.pinjaman_krd > j.batas_je then                                          -- cek apakah diatas batas yang perlu di amor
		     idae := nextval('amor_etap_id_ae_seq');
		     insert into amor_etap                                                       -- insert di amor etap
               (id_ae,id_je,id_krd,nilai_ae,reset) values
               (idae,'A',new.id_krd,kr.by_adm,false);
             if substr(kr.akta_krd,7,1) = '1' then
               sadm := '13011';
			   nocoa := j.d1_je;
             elseif substr(kr.akta_krd,7,1) = '2' then
               sadm := '13021';
			   nocoa := j.d2_je;
             else 
               sadm := '13031';
			   nocoa := j.d3_je;
             end if;
			 --select into nocoa id_coa from coa where no_coa = sadm;
		     idkredit := nextval('jurnal_detil_id_djr_seq');
             insert into jurnal_detil                                                 -- insert di jurnal detil kredit untuk amor
               (id_jr,id_djr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr)
               values
               (xjr,idkredit,sekarang(),nocoa,0,kr.by_adm,'Adm Kredit'||kt,true);
			 insert into trans_amor (id_ae,id_djr) values (idae,idkredit);            -- insert di trans_amor
           else
             sadm := '36000';                                                         -- langsung penerimaan, tidak perlu di amor
			 nocoa := j.k_je;
			 --select into nocoa id_coa from coa where no_coa = sadm;
             insert into jurnal_detil                                                 -- insert di jurnal_detil biaya
               (id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr)
               values
               (xjr,sekarang(),nocoa,0,kr.by_adm,'Adm Kredit'||kt,true);
           end if;
		 end if;    -- kr.by_adm

         if kr.by_asuransi > 0 then                     -- penanganan biaya asuransi
           if kr.pinjaman_krd > 5000000 then
             sprov := '25001';
           else
             sprov := '25001';
           end if; 
           select into nocoa id_coa from coa where no_coa = sprov;                 
           insert into jurnal_detil                                          -- insert biaya asuransi di jurnal_detil
             (id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr
             )
             values
             (xjr,sekarang(),nocoa,0,kr.by_asuransi,'Asuransi'||kt,true
             );
         end if;
		 
         if kr.by_provisi > 0 then                                                        -- penanganan provisi -- koreksi_amor1 200519
		   select into j * from jenis_etap where id_je = 'P';
           if kr.pinjaman_krd > j.batas_je then
		     idae := nextval('amor_etap_id_ae_seq');
		     insert into amor_etap                                                        -- insert provisi di amor_etap
               (id_ae,id_je,id_krd,nilai_ae,reset) values
               (idae,'P',new.id_krd,kr.by_provisi,false);
             if substr(kr.akta_krd,7,1) = '1' then
               sprov := '13011';
			   nocoa := j.d1_je;
             elseif substr(kr.akta_krd,7,1) = '2' then
               sprov := '13021';
			   nocoa := j.d2_je;
             else 
               sprov := '13031';
			   nocoa := j.d3_je;
             end if;
             --select into nocoa id_coa from coa where no_coa = sprov;
			 idkredit := nextval('jurnal_detil_id_djr_seq');
             insert into jurnal_detil                                                      -- insert di jurnal_detl
               (id_jr,id_djr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr)
               values
               (xjr,id_djr,sekarang(),nocoa,0,kr.by_provisi,'Provisi'||kt,true);
             insert into trans_amor (id_ae,id_djr) values (idae,idkredit);                 -- insert di trans_amor
           else
             sprov := '35001';
			 nocoa := j.k_je;
			 --select into nocoa id_coa from coa where no_coa = sprov;
             insert into jurnal_detil
               (id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr)
               values
               (xjr,sekarang(),nocoa,0,kr.by_provisi,'Provisi'||kt,true);
           end if; -- kr.pinjaman_krd     
         end if; -- kr.by_provisi

         if kr.fidusia_krd > 0 then                                                        -- biaya fidusia 3 mar 17
           select into nocoa id_coa from coa where no_coa = '25002';
           insert into jurnal_detil
             (id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr
             )
             values
             (xjr,sekarang(),nocoa,0,kr.fidusia_krd,'Fidusia'||kt,true
             );
         end if; 
		                                                                              -- koreksi_amor1 200519
		 if kr.komisi_krd > 0 then                                                    -- biasanya komisi_krd belum dimasukan, tetapi tetap ditangani
		   select into j * from jenis_etap where id_je = 'K';
           if kr.pinjaman_krd > j.batas_je then                                       -- cek apakah diatas batas yang perlu di amor
		     idae := nextval('amor_etap_id_ae_seq');
		     insert into amor_etap                                                    -- insert di amor etap
               (id_ae,id_je,id_krd,nilai_ae,reset) values
               (idae,'K',new.id_krd,kr.komisi_krd,false);
             if substr(kr.akta_krd,7,1) = '1' then
               sadm := '13012';
			   nocoa2 := j.k_je;                                                      -- coa beban ditangguhkan untuk kredit
			   nocoa := j.k1_je;                                                      -- coa untuk debet (k1 = kredit untuk amor)
             elseif substr(kr.akta_krd,7,1) = '2' then
               sadm := '13022';
			   nocoa2 := j.k_je;
			   nocoa := j.k2_je;
             else 
               sadm := '13032';
			   nocoa2 := j.k_je;
			   nocoa := j.k3_je;
             end if;
			 --select into nocoa id_coa from coa where no_coa = sadm;
		     iddebet := nextval('jurnal_detil_id_djr_seq');
             insert into jurnal_detil                                                 -- insert di jurnal detil debet untuk komisi
               (id_jr,id_djr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr)
               values
               (xjr,iddebet,sekarang(),nocoa,kr.komisi_krd,0,'Komisi Kredit'||kt,true);
			 insert into trans_amor (id_ae,id_djr) values (idae,iddebet);             -- insert di trans_amor
			 insert into jurnal_detil                                                 -- insert di jurnal detil kredit untuk komisi
               (id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr)
               values
               (xjr,sekarang(),nocoa2,0,kr.komisi_krd,'Komisi Kredit'||kt,true);
           else
             sadm := '45002';                                                         -- langsung di biayakan, tidak perlu di amor
			 nocoa2 := j.d_je;                                                        -- debet
			 nocoa := j.k_je;                                                         -- kredit
			 --select into nocoa id_coa from coa where no_coa = sadm;
			 insert into jurnal_detil                                                 -- insert di jurnal_detil biaya
               (id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr)
               values
               (xjr,sekarang(),nocoa2,kr.komisi_krd,0,'Komisi Kredit'||kt,true);
             insert into jurnal_detil                                                 -- insert di jurnal_detil biaya
               (id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr)
               values
               (xjr,sekarang(),nocoa,0,kr.komisi_krd,'Komisi Kredit'||kt,true);
           end if;
		 end if;    -- kr.komisi_krd 
                                                                                      -- koreksi_amor1 200519
		 if kr.mediator_krd > 0 then                                                  -- biasanya mediator_krd belum dimasukan, tetapi tetap ditangani
		   select into j * from jenis_etap where id_je = 'M';
           if kr.pinjaman_krd > j.batas_je then                                       -- cek apakah diatas batas yang perlu di amor
		     idae := nextval('amor_etap_id_ae_seq');
		     insert into amor_etap                                                    -- insert di amor etap
               (id_ae,id_je,id_krd,nilai_ae,reset) values
               (idae,'M',new.id_krd,kr.komisi_krd,false);
             if substr(kr.akta_krd,7,1) = '1' then
               sadm := '13012';			   
			   nocoa2 := j.k_je;                                                      -- coa beban ditangguhkan untuk kredit
			   nocoa := j.k1_je;                                                      -- coa untuk debet (k1 = kredit untuk amor)
             elseif substr(kr.akta_krd,7,1) = '2' then
               sadm := '13022';
			   nocoa2 := j.k_je;                                                      -- coa beban ditangguhkan untuk kredit
			   nocoa := j.k2_je;                                                      -- coa untuk debet (k1 = kredit untuk amor)
             else 
               sadm := '13032';
			   nocoa2 := j.k_je;                                                      -- coa beban ditangguhkan untuk kredit
			   nocoa := j.k3_je;                                                      -- coa untuk debet (k1 = kredit untuk amor)
             end if;
			 --select into nocoa id_coa from coa where no_coa = sadm;
		     iddebet := nextval('jurnal_detil_id_djr_seq');
             insert into jurnal_detil                                                 -- insert di jurnal detil debit untuk mediator
               (id_jr,id_djr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr)
               values
               (xjr,iddebet,sekarang(),nocoa,kr.mediator_krd,0,'Mediator Kredit'||kt,true);
			 insert into trans_amor (id_ae,id_djr) values (idae,iddebet);             -- insert di trans_amor
			 insert into jurnal_detil                                                 -- insert di jurnal detil kredit untuk mediator
               (id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr)
               values
               (xjr,sekarang(),nocoa2,0,kr.mediator_krd,'Mediator Kredit'||kt,true);
           else
             sadm := '44018';                                                         -- langsung di biayakan, tidak perlu di amor
			 nocoa2 := j.d_je;                                                        -- debet
			 nocoa := j.k_je;                                                         -- kredit
			 --select into nocoa id_coa from coa where no_coa = sadm;
			 insert into jurnal_detil                                                 -- insert di jurnal_detil biaya
               (id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr)
               values
               (xjr,sekarang(),nocoa2,kr.mediator_krd,0,'Mediator Kredit'||kt,true);
             insert into jurnal_detil                                                 -- insert di jurnal_detil biaya
               (id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr)
               values
               (xjr,sekarang(),nocoa,0,kr.mediator_krd,'Mediator Kredit'||kt,true);
           end if;
		 end if;    -- kr.mediator_krd 
		 
         select into nocoa id_coa from coa where no_coa = '20001';  -- transaksi pencairan ke tabungan
 --        select into norektab no_rek from reknas where id_rek = kr.ambildari_krd;
         if kr.typebunga_krd = 'A' then
           insert into jurnal_detil
             (id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr
             )
             values
             (xjr,sekarang(),nocoa,0,nonul(new.pokokt_xkrd)-nonul(kr.by_adm)-nonul(kr.by_asuransi)-nonul(kr.by_provisi)-nonul(kr.fidusia_krd)-nonul(kr.angsur_krd),rk.akta_krd||'/'||rk.nama_nas,true
             );
         else
           insert into jurnal_detil
             (id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr
             )
             values
             (xjr,sekarang(),nocoa,0,nonul(new.pokokt_xkrd)-nonul(kr.by_adm)-nonul(kr.by_asuransi)-nonul(kr.by_provisi)-nonul(kr.fidusia_krd),rk.akta_krd||'/'||rk.nama_nas,true
             );
         end if;
         if kr.typebunga_krd = 'A' then  -- insert di jurnal_detil untuk cicilan pertama in Advance
--di kredit modal kerja dll
           if kr.biguna_krd ='10' then
             select into nocoa id_coa from coa where no_coa = '13010';
           elsif kr.biguna_krd = '20' then
             select into nocoa id_coa from coa where no_coa = '13020';
           else
             select into nocoa id_coa from coa where no_coa = '13030';
           end if;
           insert into jurnal_detil
             (id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr
             )
             values
             (xjr,sekarang(),nocoa,0,kr.angsur_krd,'POKOK'||kt,true
             );
         end if;
--  Dari OB-sheet.sql untuk hapus buku (dihapus --* tgl 4 sept 2015, karena direksi memutuskan untuk jurnal manual pada saat hapus buku)
       elsif new.id_sandi = '38' or new.id_sandi = '39' then /* hapus buku & hapus tagih tidak perlu generate jurnal keu */

       else
         FOR p IN select id_coa,tab_prs,dk_prs,field_prs from proses where id_sandi = kode order by dk_prs LOOP
            k :=0;
            d :=0;
            if p.dk_prs = 'K' then
              k:= hitisi('K'::text,new.id_xkrd::int4,p.field_prs::int2);
            else
              d:= hitisi('K'::text,new.id_xkrd::int4,p.field_prs::int2);
            end if;
            insert into jurnal_detil
             (id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,ket_djr,posted_djr
             )
             values
             (xjr,sekarang(),p.id_coa,d,k,kt,true
             );
         END LOOP;
       end if;
     end if;

     if new.id_sandi = '30' then
     end if;
  end if;
  return new;
end;

$BODY$;
----------------------==================================================
 
   -- Function: public.amor_etap()

-- DROP FUNCTION public.amor_etap();

CREATE OR REPLACE FUNCTION public.amor_etap()
  RETURNS integer AS
$BODY$declare

  ae int4;
  nojur int4;
  acr record;
  je record;
  jem record;
  jed int4;
  jek int4;
  nocoa int4;
  skr date;
  bt text;
  keter text;
  amorbini numeric(15,0);
  jedbt int4;
  jekrd int4;
  iddebet int4;
  idkredit int4;

begin 

 skr := sekarang();
  nojur := 0;

-- P R O V I S I 
  select into je * from jenis_etap where id_je = 'P';
  for acr in select prov_daily_amor.*, nama_nas, akta_krd
      from prov_daily_amor
        join kredit using (id_krd)
        join reknas using (id_rek)
        join nasabah using (id_nas)
      where amor_bulanini > 0  
      order by kredit.id_krd
  loop
    if nojur = 0 then
      nojur := nextval('transjr_id_jr_seq');
      bt := no_ledger('77');
      insert into transjr (
        id_jr,id_com,entryop_jr,tglbuku_jr,ket_jr,
        posted_jr, bukti_jr
        ) values (
        nojur,'1','System',skr,'Jurnal Amortisasi Etap',
        skr, bt
      );
    end if;

    if substr(acr.akta_krd,7,1) ='1' then
      jedbt := je.d1_je;
      jekrd := je.k1_je;
    elseif substr(acr.akta_krd,7,1) ='2' then
      jedbt := je.d2_je;
      jekrd := je.k2_je;   
    else
      jedbt := je.d3_je;
      jekrd := je.k3_je;
    end if;

    iddebet := nextval('jurnal_detil_id_djr_seq'); 
    insert into jurnal_detil (
        id_jr,id_djr,tgl_djr,id_coa,debet_djr,kredit_djr,
        entry_op_xdep, posted_djr,ket_djr
         ) values (
           nojur,iddebet,skr, jedbt,acr.amor_bulanini,0,
           'System',true,'Amortisasi Provisi '|| acr.nama_nas||'/'||acr.akta_krd
         );
    insert into jurnal_detil (
        id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,
        entry_op_xdep, posted_djr,ket_djr
         ) values (
           nojur,skr, jekrd,0,acr.amor_bulanini,
           'System',true,'Amortisasi Provisi '|| acr.nama_nas||'/'||acr.akta_krd
         );
     insert into trans_amor (id_ae,id_djr,debet_xa) values(acr.id_ae,iddebet,acr.amor_bulanini);
      
     update amor_etap
       set  sisa_ae = sisa_ae - acr.amor_bulanini
       where id_krd = acr.id_krd and id_je = 'P' ;
  end loop;
  
  -- A D M

  select into je * from jenis_etap where id_je = 'A';
  for acr in select adm_daily_amor.*, nama_nas, akta_krd
      from adm_daily_amor
        join kredit using (id_krd)
        join reknas using (id_rek)
        join nasabah using (id_nas)
      where amor_bulanini > 0  
      order by kredit.id_krd
  loop
    if nojur = 0 then
      nojur := nextval('transjr_id_jr_seq');
      bt := no_ledger('77');
      insert into transjr (
        id_jr,id_com,entryop_jr,tglbuku_jr,ket_jr,
        posted_jr, bukti_jr
        ) values (
        nojur,'1','System',skr,'Jurnal Amortisasi Etap',
        skr, bt
      );
    end if;

    if substr(acr.akta_krd,7,1) ='1' then
      jedbt := je.d1_je;
      jekrd := je.k1_je;
    elseif substr(acr.akta_krd,7,1) ='2' then
      jedbt := je.d2_je;
      jekrd := je.k2_je;   
    else
      jedbt := je.d3_je;
      jekrd := je.k3_je;
    end if;


    iddebet := nextval('jurnal_detil_id_djr_seq'); 
    insert into jurnal_detil (
        id_jr,id_djr,tgl_djr,id_coa,debet_djr,kredit_djr,
        entry_op_xdep, posted_djr,ket_djr
         ) values (
           nojur,iddebet,skr, jedbt,acr.amor_bulanini,0,
           'System',true,'Amortisasi Adm '|| acr.nama_nas||'/'||acr.akta_krd
         );

    insert into jurnal_detil (
        id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,
        entry_op_xdep, posted_djr,ket_djr
         ) values (
           nojur,skr, jekrd,0,acr.amor_bulanini,
           'System',true,'Amortisasi Adm '|| acr.nama_nas||'/'||acr.akta_krd
         );
    insert into trans_amor (id_ae,id_djr,debet_xa) values(acr.id_ae,iddebet,acr.amor_bulanini);
     update amor_etap
       set  sisa_ae = sisa_ae - acr.amor_bulanini
       where id_krd = acr.id_krd and id_je = 'A' ;

  end loop;

  -- MEDIATOR INADVANCE

  select into jem * from jenis_etap where id_je = 'M';
  for acr in select kredit.*, amor_etap.*, nama_nas 
    from kredit join amor_etap using (id_krd) join reknas using (id_rek) join nasabah using (id_nas)
    where tgl_mediator_krd = sekarang() and id_je = 'M' and kredit.typebunga_krd = 'A'  order by akta_krd
  loop
    if nojur = 0 then
      nojur := nextval('transjr_id_jr_seq');
      bt := no_ledger('77');

      insert into transjr (
        id_jr,id_com,entryop_jr,tglbuku_jr,ket_jr,
        posted_jr, bukti_jr
        ) values (
        nojur,'1','System',skr,'Jurnal Amortisasi Etap',
        skr, bt
      );
    end if;

    if acr.id_je = 'M' then
        keter = 'Amortisasi Pertama (InAdvance) Mediator ';
        if substr(acr.akta_krd,7,1) ='1' then
          jek := jem.k1_je;
          jed := jem.d1_je;
        elseif substr(acr.akta_krd,7,1) ='2' then
          jek := jem.k2_je;
          jed := jem.d2_je;   
        else
         jek := jem.k3_je;
         jed := jem.d3_je;
        end if;
    end if;

    insert into jurnal_detil (
        id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,
        entry_op_xdep, posted_djr,ket_djr
         ) values (
           nojur,skr, jed,acr.amor_ae,0,
           'System',true,keter|| acr.nama_nas||'/'||acr.akta_krd
         );

    idkredit := nextval('jurnal_detil_id_djr_seq'); 
    insert into jurnal_detil (
        id_jr,id_djr,tgl_djr,id_coa,debet_djr,kredit_djr,
        entry_op_xdep, posted_djr,ket_djr
         ) values (
           nojur,idkredit,skr, jek,0,acr.amor_ae,
           'System',true,keter|| acr.nama_nas||'/'||acr.akta_krd
         );
    insert into trans_amor (id_ae,id_djr,kredit_xa) values(acr.id_ae,idkredit,acr.amor_bulanini);
     update amor_etap
       set  sisa_ae = sisa_ae - acr.amor_ae
       where id_krd = acr.id_krd and id_je = 'M' ;
  end loop;

-- K O M I S I INADVANCE
  select into jem * from jenis_etap where id_je = 'K';
  for acr in select kredit.*, amor_etap.*, nama_nas 
    from kredit join amor_etap using (id_krd) join reknas using (id_rek) join nasabah using (id_nas)
    where tgl_komisi_krd = sekarang() and id_je = 'K' and kredit.typebunga_krd = 'A' order by akta_krd
  loop
    if nojur = 0 then
      nojur := nextval('transjr_id_jr_seq');
      bt := no_ledger('77');

      insert into transjr (
        id_jr,id_com,entryop_jr,tglbuku_jr,ket_jr,
        posted_jr, bukti_jr
        ) values (
        nojur,'1','System',skr,'Jurnal Amortisasi Etap',
        skr, bt
      );
    end if;

    if acr.id_je = 'K' then
        keter = 'Amortisasi Pertama (InAdvance) Komisi ';
        if substr(acr.akta_krd,7,1) ='1' then
          jek := jem.k1_je;
          jed := jem.d1_je;
        elseif substr(acr.akta_krd,7,1) ='2' then
          jek := jem.k2_je;
          jed := jem.d2_je;   
        else
         jek := jem.k3_je;
         jed := jem.d3_je;
        end if;
    end if;
 
    insert into jurnal_detil (
        id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,
        entry_op_xdep, posted_djr,ket_djr
         ) values (
           nojur,skr, jed,acr.amor_ae,0,
           'System',true,keter|| acr.nama_nas||'/'||acr.akta_krd
         );

    idkredit := nextval('jurnal_detil_id_djr_seq'); 
    insert into jurnal_detil (
        id_jr,id_djr,tgl_djr,id_coa,debet_djr,kredit_djr,
        entry_op_xdep, posted_djr,ket_djr
         ) values (
           nojur,idkredit,skr, jek,0,acr.amor_ae,
           'System',true,keter|| acr.nama_nas||'/'||acr.akta_krd
         );
    insert into trans_amor (id_ae,id_djr,kredit_xa) values(acr.id_ae,idkredit,acr.amor_bulanini);
     update amor_etap
       set  sisa_ae = sisa_ae - acr.amor_ae
       where id_krd = acr.id_krd and id_je = 'K' ;
  end loop;

-- KOMISI DAN MEDIATOR INADVANCE

select into je * from jenis_etap where id_je = 'K';
  select into jem * from jenis_etap where id_je = 'M';
  for acr in select komisi_daily_amor.*, nasabah.nama_nas,kredit.akta_krd
      from komisi_daily_amor
        join kredit using (id_krd)
        join reknas using (id_rek)
        join nasabah using (id_nas)
        join amor3_age using (id_krd)
      where amor_bulanini > 0  and amor3_age.bln_ke >=2 and kredit.typebunga_krd = 'A'
      order by kredit.id_krd 
  loop
    if nojur = 0 then
      nojur := nextval('transjr_id_jr_seq');
      bt := no_ledger('77');

      insert into transjr (
        id_jr,id_djr,id_com,entryop_jr,tglbuku_jr,ket_jr,
        posted_jr, bukti_jr
        ) values (
        nojur,idkredit,'1','System',skr,'Jurnal Amortisasi Etap',
        skr, bt
      );
    end if;

    if acr.id_je = 'K' then
        keter = 'Amortisasi Komisi ';
        if substr(acr.akta_krd,7,1) ='1' then
          jek := je.k1_je;
          jed := je.d1_je;
        elseif substr(acr.akta_krd,7,1) ='2' then
          jek := je.k2_je;
          jed := je.d2_je;   
        else
          jek := je.k3_je;
          jed := je.d3_je;
        end if;
    
       update amor_etap
         set  sisa_ae = sisa_ae - acr.amor_bulanini
         where id_krd = acr.id_krd and id_je = 'K' ;
    else
        keter = 'Amortisasi Mediator ';
        if substr(acr.akta_krd,7,1) ='1' then
          jek := jem.k1_je;
          jed := jem.d1_je;
        elseif substr(acr.akta_krd,7,1) ='2' then
          jek := jem.k2_je;
          jed := jem.d2_je;   
        else
         jek := jem.k3_je;
         jed := jem.d3_je;
        end if;
    
    update amor_etap
         set  sisa_ae = sisa_ae - acr.amor_bulanini
         where id_krd = acr.id_krd and id_je = 'M' ;
    end if;

    insert into jurnal_detil (
        id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,
        entry_op_xdep, posted_djr,ket_djr
         ) values (
           nojur,skr, jed,acr.amor_bulanini,0,
           'System',true,keter|| acr.nama_nas||'/'||acr.akta_krd
         );

    idkredit := nextval('jurnal_detil_id_djr_seq'); 
    insert into jurnal_detil (
        id_jr,id_djr,tgl_djr,id_coa,debet_djr,kredit_djr,
        entry_op_xdep, posted_djr,ket_djr
         ) values (
           nojur,idkredit,skr, jek,0,acr.amor_bulanini,
           'System',true,keter|| acr.nama_nas||'/'||acr.akta_krd
         );
    insert into trans_amor (id_ae,id_djr,kredit_xa) values(acr.id_ae,idkredit,acr.amor_bulanini);
  end loop;
    
-- KOMISI AND MEDIATOR NOT INADVANCE

  select into je * from jenis_etap where id_je = 'K';
  select into jem * from jenis_etap where id_je = 'M';
  for acr in select komisi_daily_amor.*, nasabah.nama_nas,kredit.akta_krd
      from komisi_daily_amor
        join kredit using (id_krd)
        join reknas using (id_rek)
        join nasabah using (id_nas)
        join amor3_age using (id_krd)
      where amor_bulanini > 0  and amor3_age.bln_ke >=1 and kredit.typebunga_krd <> 'A'
      order by kredit.id_krd 
  loop
    if nojur = 0 then
      nojur := nextval('transjr_id_jr_seq');
      bt := no_ledger('77');

      insert into transjr (
        id_jr,id_com,entryop_jr,tglbuku_jr,ket_jr,
        posted_jr, bukti_jr
        ) values (
        nojur,'1','System',skr,'Jurnal Amortisasi Etap',
        skr, bt
      );
    end if;

    if acr.id_je = 'K' then
        keter = 'Amortisasi Komisi ';
        if substr(acr.akta_krd,7,1) ='1' then
          jek := je.k1_je;
          jed := je.d1_je;
        elseif substr(acr.akta_krd,7,1) ='2' then
          jek := je.k2_je;
          jed := je.d2_je;   
        else
          jek := je.k3_je;
          jed := je.d3_je;
        end if;
    
       update amor_etap
         set  sisa_ae = sisa_ae - acr.amor_bulanini
         where id_krd = acr.id_krd and id_je = 'K' ;
    else
        keter = 'Amortisasi Mediator ';
        if substr(acr.akta_krd,7,1) ='1' then
          jek := jem.k1_je;
          jed := jem.d1_je;
        elseif substr(acr.akta_krd,7,1) ='2' then
          jek := jem.k2_je;
          jed := jem.d2_je;   
        else
         jek := jem.k3_je;
         jed := jem.d3_je;
        end if;
  
       
    update amor_etap
         set  sisa_ae = sisa_ae - acr.amor_bulanini
         where id_krd = acr.id_krd and id_je = 'M' ;
    end if;

    insert into jurnal_detil (
        id_jr,tgl_djr,id_coa,debet_djr,kredit_djr,
        entry_op_xdep, posted_djr,ket_djr
         ) values (
           nojur,skr, jed,acr.amor_bulanini,0,
           'System',true,keter|| acr.nama_nas||'/'||acr.akta_krd
         );

    idkredit := nextval('jurnal_detil_id_djr_seq');
    insert into jurnal_detil (
        id_jr,id_djr,tgl_djr,id_coa,debet_djr,kredit_djr,
        entry_op_xdep, posted_djr,ket_djr
         ) values (
           nojur,idkredit,skr, jek,0,acr.amor_bulanini,
           'System',true,keter|| acr.nama_nas||'/'||acr.akta_krd
         );
   insert into trans_amor (id_ae,id_djr,kredit_xa) values(acr.id_ae,idkredit,acr.amor_bulanini);
    end loop;

  return 1;

end; -- end of amor_etap()

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.amor_etap()
  OWNER TO bprdba;
