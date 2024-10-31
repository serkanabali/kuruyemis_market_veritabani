use Kuruyemis
--
select UrunID+' '+UrunFiyat as Urun from Urun
--
select DepoID+' '+StokKodu+' '+ Convert(nvarchar,MiktarKg) from Stok
--
select CalisanlarAdi+' '+Pozisyon+' '+ Cast(CalisanlarTel as nvarchar) from Calisanlar
--
select CalisanlarAdi ,SUBSTRING (CalisanlarAdi, 1, 5) as SadeceAd from Calisanlar where CalisanlarAdi= 'ZEMZEM AKÝ'
--
select CalisanlarAdi ,CHARINDEX(' ', CalisanlarAdi) as sinir from Calisanlar
--
select SUBSTRING (CalisanlarAdi, 1, CHARINDEX (' ', CalisanlarAdi) ) as sadeceAd from Calisanlar
--
select P1.DepoAdi as 'depo adi', P1.DepoAdres as 'depo soyad', P2.TedarikciAdi, P2.TedarikciAdres
from  Depo P1 inner join Tedarikci P2
on P1.tedarikciId=P2.TedarikciID
--
select * from Calisanlar where CalisanlarAdi like'a% k%'
--
select TedarikciID,
	case
		when TedarikciID=1 then 'Doðu'
		when TedarikciID=2 then 'Batý'
		when TedarikciID=3 then 'Kuzey'
		when TedarikciID=4 then 'Güney'
		else 'Bolge Bilgisi Yok'
		end
		as DepoAdi
		into Kopya
from Depo
--
select DepoAdres,DepoAdi D from Depo
where TedarikciID=(
				select TedarikciID from Tedarikci
				where TedarikciAdi like 'peyman%'
				)
--
select TedarikciAdi, TedarikciAdres, TedarikciID
from Tedarikci
where TedarikciID=	(select TedarikciID
				from Depo
				where TedarikciID=	(select TedarikciID
									from Depo
									where DepoID like '101'))
--
select top 3 with ties DepoID*MiktarKg as 'Tutar' from Stok order by Tutar desc
--
update Stok set StokKodu=UrunID
from Stok S inner join Urun U
on S.StokKodu=U.UrunID
--
select UrunID, UrunAdi, sum(UrunFiyat*2) from Urun group by UrunID, UrunAdi with rollup
--
select UrunID,UrunAdi, sum(UrunFiyat*2) from Urun group by UrunID, UrunAdi with cube
--
select UrunID,UrunAdi, sum(UrunFiyat*2) from Urun group by UrunID, UrunAdi with rollup
having sum(UrunFiyat*2) >300
--
select UrunID,UrunAdi, sum(UrunFiyat*2) from Urun group by UrunID, UrunAdi with cube
having sum(UrunFiyat*2) >300
--
select StokKodu, coalesce(MiktarKg, 0)as KG from Stok
--
select StokKodu,
	case
		when MiktarKg is null then 'Stokta Yok'
		end
		as 'Stokta Olmayanlar'
from Stok
--
select SatisID, isnull(SatisTarih, '01-01-2000') as 'Satis Tarihi' from Satis
--
select MusteriID, MusteriAdi, coalesce(MusteriAdi, 'Ad Yok') as 'Yeni Musteri Adi' from Musteri
--
select TedarikciID,TedarikciAdres, isnull(TedarikciAdi, 'Ad bilgisi yoktur')as tedarikciAdi from Tedarikci
--
select TedarikciID,TedarikciAdi, isnull(TedarikciAdres, 'Adres bilgisi yoktur')as adres from Tedarikci
--
select TedarikciID,TedarikciAdres, coalesce(TedarikciAdi, 'Ad bilgisi yoktur') from Tedarikci
--
select  StokKodu, MiktarKg ,isnull(MiktarKg, 0) as 'Stok Yok'
from Stok S
inner join
Urun U
on S.StokKodu = U.UrunID
--
create view KatliSatis as
select u.UrunAdi,SUM(u.UrunFiyat*2)as KatliFiyat from Urun u
inner join Stok s
on
u.UrunID=s.StokKodu
group by u.UrunAdi
--
select UrunAdi, sum(KatliFiyat) as katlifiyat from KatliSatis group by UrunAdi order by katlifiyat desc
--
declare @d1 float = 0
set @d1=(
		select top 1 sum(S.MiktarKg*U.UrunFiyat) from Stok S
		inner join Urun U
		on S.StokKodu=U.UrunID
		order by sum(S.MiktarKg*U.UrunFiyat) desc
		)
select @d1
--
select avg (nullif (MiktarKg, 0)) from Stok
--
DBCC checkident (Calisanlar, reseed, 100)
--
create database Kuruyemis
on
(
name='VTU_mdl',
filename='C:\Users\OGRENCI\kuruyemis.mdf',
size=16,
FileGrowth=8
)
log on
(
name='VTU_ldf',
filename='C:\Users\OGRENCI\kuruyemis.ldf',
size=16,
FileGrowth=8
)
--
alter table Depo Add Constraint PKDepo Primary Key(DepoID)
--
alter table Depo Add Constraint UKDepo Unique (DepoAdi)
--
alter table Stok add constraint FKStokDepo Foreign Key (DepoID) References Depo (DepoID)
--
select * from Urun where UrunID=120001
select @@ROWCOUNT
--
declare @d1 int=120001
select * from Urun where UrunID=@d1
select @@ROWCOUNT
--
if @@ROWCOUNT>0
print 'urun var'
else
print 'urun yok'
--
declare @vize int=90
declare @final int=70
--
if @vize>@final
begin
select @vize*0.5 + @final*0.3 [sonuç] print 'vize yüksek'
end
else
begin
select @vize*0.3 + @final*0.5 [sonuç] print 'final yükek'
end
--
alter table Urun add constraint Def_Const default 'Stok yok' for MiktarKg
--
create database deneme
go
use deneme
go
create table Tablo (
					ID int,
					Ad nvarchar(20),
					Soyad nvarchar(20),
					Mail nvarchar(30),
					Sifre uniqueidentifier)
go
insert into Tablo values (1, 'ali', 'yýlmaz', 'ayilmaz@mail.com', NewID() )
--
select * into #Gecici_Calisanlar from Calisanlar
--
declare @d4 int= 1
while @d4<100
begin
print @d4
set @d4+=1
if @d4%5=0
break
end
--
create view DusukStok
as
	select *
	from dbo.Stok
	where MiktarKg < 50
with check option
select * from DusukStok
--
create view Encryp_Urun
with encryption
as
select U.UrunAdi, sum (U.UrunFiyat*S.StokKodu)
from Stok S
	inner join Urun U
	on S.StokKodu=U.UrunID
	group by S.StokKodu, U.UrunID
--
create view V_YeniStok
with schemabinding
as
select StokKodu [STOKKODU] from dbo.Stok where MiktarKg>100

select * from V_YeniStok
--
create function dbo.StokTakip (@UrunKodu nvarchar(max), @MiktarKg nvarchar(max))
	returns nvarchar(max)
	as
	begin
	declare @bilgi nvarchar(max) = @UrunKodu + 'kodlu urunun'+ @MiktarKg + 'adet stogu var'
	return @bilgi
	end