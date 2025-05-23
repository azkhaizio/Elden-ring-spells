alter table tb2
add DMG_Type nvarchar(255) ,
 Note nvarchar (255) ,
 Hits float ,
 Net_AR float ,
 Net_AR_per_FP float,
 Net_DMG float ,
 Net_DMG_per_FP float ,
 Chain float ,
 Followup float ,
 Base_AR_Breakdown nvarchar(255);

update tb2 
set DMG_Type = 'None' ,
 Note = 'None' ,
 Hits = 0,
 Net_AR = 0,
 Net_AR_per_FP = 0,
 Net_DMG = 0,
 Net_DMG_per_FP = 0,
 Chain = 0,
 Followup = 0,
 Base_AR_Breakdown = 'None';

SELECT Name, Type, DMG_Type, Note, FP, Hits, Net_AR, Net_AR_per_FP, Net_DMG, Net_DMG_per_FP,
       Charge, Chain, Followup, Channel, Movement, Horseback, Int, Fai, Arc, Base_AR_Breakdown
INTO tb3
FROM (
    SELECT Name, Type, DMG_Type, Note, FP, Hits, Net_AR, Net_AR_per_FP, Net_DMG, Net_DMG_per_FP,
           Charge, Chain, Followup, Channel, Movement, Horseback, Int, Fai, Arc, Base_AR_Breakdown
    FROM tb1
    UNION
    SELECT Name, Type, DMG_Type, Note, FP, Hits, Net_AR, Net_AR_per_FP, Net_DMG, Net_DMG_per_FP,
           Charge, Chain, Followup, Channel, Movement, Horseback, Int, Fai, Arc, Base_AR_Breakdown
    FROM tb2
) AS UnionResult;
-- tạo column mới: tổng số cấp rune cần thiết để sử dụng và số điểm đánh giá utility của spell
alter table tb3
add skill_sum as ( tb3.int + tb3.fai + tb3.arc) ,
utility_sum as (tb3.Charge + tb3.Chain +tb3.Followup + tb3.Channel +tb3.Movement +tb3.Horseback) ;

-- điều chỉnh các dữ liệu bị thiếu và join table
select name, description, effect, slot, stamina_cost, bonus,[group], location, dlc
into tb4
from(
select*from incantations
union
select* from sorceries) as unionresult1;

WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY name ORDER BY tb3.Net_AR desc) AS rn
    FROM tb3
)
DELETE FROM CTE
WHERE rn > 1;

with cte_1 as
(select right(name,3) as rightnum
       from tb3)
delete from cte_1 
where rightnum = '(1)' or rightnum = '(2)' or rightnum = '(3)'

INSERT INTO tb3 (
    Name, Type, DMG_Type, Note, FP, Hits, Net_AR, Net_AR_per_FP, Net_DMG, Net_DMG_per_FP,
    Charge, Chain, Followup, Channel, Movement, Horseback, Int, Fai, Arc, Base_AR_Breakdown
)
VALUES 
('Black Blade', 'Incantation', 'Physical', 'Two attacks', 26, 1, 274, 10.53, 246, 9.46, 0, 0, 1, 0, 0, 0, 0, 46, 0, '225 (Sword)'),

('Briars of Sin', 'Sorcery', 'Magic', 'None', 6, 1, 120, 20, 108, 18, 0, 0, 1, 0, 0, 0, 0, 24, 0, '200'),

('Dragonclaw', 'Incantation', 'Physical', 'Two attacks', 24, 1, 237, 9.88, 213.3, 8.89, 0, 0, 0, 1, 0, 0, 0, 17, 13, '395 (Direct Hit)'),

('Fortissax''s Lightning Spear', 'Incantation', 'Lightning', 'Two attacks', 35, 1, 444, 12.68, 403, 11.51, 0, 0, 0, 0, 0, 0, 0, 46, 0, '367 (Impact)'),

('Gavel of Haima', 'Sorcery', 'Magic', 'None', 22, 1, 178.2, 8.1, 160.38, 7.29, 0, 0, 1, 0, 0, 0, 25, 0, 0, '297'),

('Shatter Earth', 'Sorcery', 'Magic', 'Two attacks', 10, 3, 253, 25.3, 226, 22.6, 0, 0, 1, 0, 0, 0, 15, 0, 0, '68 (Drill), 52 (Drill), 52 (Drill)');


UPDATE tb3
SET Name =  'Terra Magica'
WHERE Name = 'Terra Magicus';



SELECT 
    tb3.Name,
    tb3.Type,
    tb3.DMG_Type,
    tb3.FP,
    tb3.Hits,
    tb4.[group],
    tb4.bonus,
    tb4.slot,
    tb4.stamina_cost,
    tb3.Net_AR,
    tb3.Net_AR_per_FP,
    tb3.Charge,
    tb3.Chain,
    tb3.Followup,
    tb3.Movement,
    tb3.Horseback,
    tb3.Int,
    tb3.Fai,
    tb3.Arc,
    tb4.description,
    tb4.effect,
    tb4.location,
    tb3.skill_sum,
	tb3.utility_sum
	
INTO final_table
FROM tb3
LEFT JOIN tb4 ON tb3.Name = tb4.name


-- 5 spells yêu cầu chỉ số cao nhất
select top 5 final_table.Name, final_table.skill_sum,final_table.Type
from final_table
order by final_table.skill_sum desc

--top 5 spells có thể hit and run 
select top 5 final_table.Name, final_table.stamina_cost
from final_table
where final_table.Movement = 1 and final_table.Horseback = 1
order by final_table.stamina_cost asc

-- top 5 spells có damage cao nhất tính theo mỗi FP(mana) sử dụng
select top 5 final_table.Name, final_table.Net_AR_per_FP
from final_table
order by final_table.Net_AR_per_FP desc

-- có tổng cộng 101 incantation và 70 spell ở base game
select Type, count(Type) as Spell_number 
from final_table
group by Type

-- loại damage nào có sát thương trung bình cao nhất: mixed >lightning> physical~Holy~Fire
select DMG_Type, COUNT(DMG_Type), avg(Net_AR)
from final_table
group by DMG_Type

-- có tổng cộng 14 spell chiếm hơn 1 slot 
select Name,FP, slot
from final_table
where slot >1

-- trong số 171 spell, có thể mua được 68 spell, còn lại phải loot hoặc được drop khi đánh boss
SELECT Name, location
FROM final_table	
WHERE location LIKE '%Purchased%' 
   OR location LIKE '%Purchase%' 
   OR location LIKE '%Sold%' 
   OR location LIKE '%Purchasable%'

-- các spell thuần faith chiếm số lượng nhiều nhất, các spell hybrid còn nhiều hơn thuần int, không có một spell nào thuần arcane
with spell_att as (
SELECT 
  CASE 
    WHEN Int = 0 AND Fai = 0 AND Arc != 0 THEN 'Pure arcane'
    WHEN Int = 0 AND Arc = 0 AND Fai != 0 THEN 'Pure faith'
    WHEN Fai = 0 AND Arc = 0 AND Int != 0 THEN 'Pure Int'
    ELSE 'Hybrid'
  END AS spell_attribute
FROM final_table)

select spell_attribute,count(spell_attribute)
from spell_att
group by spell_attribute

-- các spell thông dụng nhất toàn là các spell gây damage, với bonus lần lượt là Dragon Communion, Glintstone, Dragon Cult (các spell liên quan đến rồng khá phổ biến)
select top 3 [group], bonus, count(*) as count_spell
from final_table
group by [group], bonus
order by count_spell desc

-- Nhìn chung thì lượng damage trung bình của incantation và sorcery là bằng nhau
select type, avg(Net_AR)
from final_table
where Net_AR != 0
group by type