# Elden-ring-spells
- Được thực hiện trên Microsoft SQL Server, query này phân tích tổng những spells của tựa game nổi tiếng Elden ring ( bao gồm các sorceries và incantations, chỉ tính ở base game ko bao gồm dlc) nhằm giúp cho người chơi biết được những spells overpowered nhất để điều chỉnh lối chơi hoặc giúp game dev chỉnh sửa các spells bị lỗi , ngoài ra còn có một số insight thú vị khác cần khai thác.  
- Data được crawl từ https://jerp.tv/eldenring/spells/ và https://www.kaggle.com/datasets/pedroaltobelli/ultimate-elden-ring-with-shadow-of-the-erdtree-dlc , tham khảo từ https://eldenring.wiki.fextralife.com/Magic+Spells , tuy nhiên những dữ liệu này ko bao gồm dữ liệu liên quan người chơi
- Giải thích columns:  
Name nvarchar(255) : Tên spell  
Type nvarchar(255) : Loại spell ( Sorcery hoặc Incantation)
DMG_Type nvarchar(255) : Thuộc tính sát thương của spell  
FP float : Lượng FP (mana) tiêu thụ của spell  
Hits float : Spell trúng bao nhiêu đòn  
Group nvarchar(50) : Spell loại nào ( Sát thương, heal, buff..)  
Bonus nvarchar(50) : Trường phép thuật của spell  
Slot tinyint : Spell chiếm bao nhiêu chỗ spell slot  
stamina_cost tinyint: Thực hiện spell mất bao nhiêu stamina  
NET_AR float : Sát thương thuần của spell  
NET_AR_per_FP float : Lượng sát thương trung bình trên mỗi mana sử dụng  
Charge float : Spell có phải vận chiêu hay không, 0 là không, 1 là có  
Chain float : Spell có thực hiện liên tục không bị ngắt quãng được không,  0 là không, 1 là có  
Followup float: Spell có thêm phase nào nữa không , 0 là không, 1 là có  
Movement float: Spell có vừa di chuyển vừa cast được không, 0 là không, 1 là có  
Horse float: Spell có vừa cưỡi ngựa vừa cast được không, 0 là không, 1 là có  
Int float: Chỉ số Intelligence cần để cast spell  
Fai float: Chỉ số Faith cần để cast spell  
Arc float: Chỉ số Arcane cần để cast spell  
Description nvarchar(500): Mô tả Spell  
Effect nvarchar(100): Hiệu ứng spell  
Location nvarchar(500): Địa điểm có được spell  
Skill_sum float: Tổng số cấp ít nhất để cast spell  
Utility_sum float: Tổng số điểm đa dụng của spell  




