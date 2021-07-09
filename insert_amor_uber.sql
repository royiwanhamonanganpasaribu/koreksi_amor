select in_log('sisa_amor_acc.sql', 'insert data ke trans_amor');


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

--UBER--
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000089,500002030,250000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000122,500002736,200000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000125,500002738,200000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000150,500003829,400000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000176,500004945,750000,0); -- tanggal dan nominal beda. 
-- insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000205,500005761,1500000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000215,500006323,4500000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000250,500009368,200000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000251,500009368,200000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000282,500011044,200000,0); -- tanggal dan nominal beda.
-- insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000301,500012728,200000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000320,500012728,200000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000351,500004373,200000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000395,500004860,200000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000444,500005363,200000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000452,500018620,750000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000480,500021360,200000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000521,500024063,200000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000522,500024063,625000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000576,500026671,200000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000583,500026671,200000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000622,500029032,200000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000792,500037695,200000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001351,500071925,75000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001353,500075407,300000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001393,500075407,150000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001395,500075411,300000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) select 500001401, id_djr, debet_djr, kredit_djr from jurnal_detil where id_djr = 500073544; -- tanggal dan nominal sama
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) select 500001402, id_djr, debet_djr, kredit_djr from jurnal_detil where id_djr = 500073546; -- tanggal dan nominal sama
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001461,500075407,50000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001462,500075407,50000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001592,500085804,200000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001593,500085804,25000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001598,500085806,100000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001644,500089597,125000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001646,500089597,50000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001650,500089597,200000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001709,500093615,75000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001706,500093615,125000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001710,500093615,100000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001712,500093615,125000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001713,500093617,50000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001716,500093615,150000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001715,500093617,150000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001759,500096961,75000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001758,500096965,200000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) select 500001760, id_djr, debet_djr, kredit_djr from jurnal_detil where id_djr = 500094603; -- tanggal dan nominal sama
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001825,500100271,125000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001826,500100271,50000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001830,500022726,25000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) select 500001831, id_djr, debet_djr, kredit_djr from jurnal_detil where id_djr = 500099771; -- tanggal dan nominal sama
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001896,500104047,75000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001899,500104049,50000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001949,500107644,50000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001950,500107644,200000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002017,500111166,50000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) select 500001984, id_djr, debet_djr, kredit_djr from jurnal_detil where id_djr = 500108912; -- tanggal dan nominal sama
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002018,500111168,50000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002019,500111168,25000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002015,500111168,200000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002014,500111168,50000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002100,500114939,25000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002101,500114937,50000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002102,500114937,50000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002103,500114939,25000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) select 500002077, id_djr, debet_djr, kredit_djr from jurnal_detil where id_djr = 500114099; -- tanggal dan nominal sama
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002148,500118658,25000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002149,500118660,50000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002150,500118658,125000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002151,500118660,50000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002152,500118658,25000,0); -- tanggal dan nominal beda. 
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002229,500122396,200000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002230,500122396,50000,0); -- tanggal dan nominal beda.  
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002231,500122394,25000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002232,500122396,50000,0); -- tanggal dan nominal beda.  
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002279,500125673,200000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002280,500125671,100000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002281,500125671,50000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002282,500125673,50000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002283,500125673,125000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002342,500129174,125000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002378,500132032,25000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002379,500132032,25000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002377,500132032,75000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002376,500132032,25000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002375,500131283,600000,0); -- tanggal dan nominal beda. 

	--BARU




insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001888,500104049,50000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001889,500104049,25000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001891,500104049,25000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001892,500104049,50000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001893,500104049,75000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001894,500104049,25000,0); -- tanggal dan nominal beda.
--terbalik
--terbalik
--OK
--OK
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001948,500107639,50000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001951,500107639,50000,0); -- tanggal dan nominal beda.
-- JU tidak ditemukan
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002344,500129176,25000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002345,500129176,25000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002346,500129176,75000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002347,500129176,50000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002341,500129176,25000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002343,500129176,25000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) select 500002322, id_djr, debet_djr, kredit_djr from jurnal_detil where id_djr = 500127122; -- tanggal dan nominal sama
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001065,500052538,250000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001062,500052538,750000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001113,500055683,400000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001115,500055683,300000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001205,500062003,50000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001714,500093615,200000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000205,500005761,1500000,0); -- tanggal dan nominal beda.
-- insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000215,500006323,4500000,0); -- tanggal dan nominal beda.
-- insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000317,500012728,200000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000825,500040692,200000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000868,500043515,75000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000931,500046478,200000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000929,500046478,125000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000935,500046478,200000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001066,500052536,250000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001209,500062001,50000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001206,500062001,400000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001207,500062001,100000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001210,500062001,25000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001275,500065216,300000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001268,500065216,75000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001269,500065216,112500,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001314,500068584,37500,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001316,500068584,300000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001394,500075407,225000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001517,500082011,125000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001519,500082011,200000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001827,500100253,50000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001828,500100253,50000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001829,500100253,75000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002016,500111168,25000,0); -- tanggal dan nominal beda.
-- Tidak ada no JU
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002374,500132032,562500,0); -- tanggal dan nominal beda.
-- insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002404,500135273,50000,0); -- tanggal dan nominal beda.
-- insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500002405,500135275,125000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500000317,500012728,200000,0); -- tanggal dan nominal beda.


insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001898,500102811,997500,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001897,500100444,472500,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001909,500104599,2972000,0); -- tanggal dan nominal beda.
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa) values (500001945,500107330,2883500,0); -- tanggal dan nominal beda.

insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa)  select 500000189, id_djr, debet_djr, kredit_djr from jurnal_detil where id_djr = 500005677; -- tanggal dan nominal sama
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa)  select 500000188, id_djr, debet_djr, kredit_djr from jurnal_detil where id_djr = 500005675; -- tanggal dan nominal sama
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa)  select 500000207, id_djr, debet_djr, kredit_djr from jurnal_detil where id_djr = 500006265; -- tanggal dan nominal sama P
insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa)  select 500000207, id_djr, debet_djr, kredit_djr from jurnal_detil where id_djr = 500006263; -- tanggal dan nominal sama A
 

insert into trans_amor (id_ae,id_djr,debet_xa,kredit_xa)  select 500000208, id_djr, debet_djr, kredit_djr from jurnal_detil where id_djr = 500006265; -- tanggal dan nominal sama
