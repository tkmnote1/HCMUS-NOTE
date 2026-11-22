#import "@preview/euler-math:0.1.0": *
#import "@preview/cetz:0.3.4"
// ==========================================
// CÀI ĐẶT MÀU SẮC & BIẾN ĐẾM
// ==========================================
#let color-prop = rgb("#009688")  // Xanh ngọc (Mệnh đề) - nổi bật
#let bg-prop = rgb("#e0f2f1")     // Nền xanh ngọc nhạt

#let color-cau = rgb("#B4A0CB")   // Đỏ nâu
#let bg-cau = rgb("#F8F5FC")  
#let color-thm = rgb("#c00040")   // Đỏ thẫm (Định lí)
#let bg-thm = rgb("#fdf2f4")

#let color-lem = rgb("#2e7d32")   // Xanh lá (Bổ đề)
#let bg-lem = rgb("#e8f5e9")

#let color-prob = rgb("#006080")  // Xanh lam (Bài toán)
#let bg-prob = rgb("#f0f7fb")

#let color-def = rgb("#4f6d7a") // Xám xanh (Định Nghĩa)
#let bg-def = rgb("#f1f6f8")

#let color-ex =  rgb("#b35c44")    // Cam (Ví dụ)
#let bg-ex = rgb("#fcf2ee")

#let color-text = rgb("#005a8c")  // Màu chữ cho Chứng minh/Lời giải

#let thm-counter = counter("theorem")

// ==========================================
// HÀM TEMPLATE CHÍNH
// ==========================================
#let template(
  title: none,
  subtitle: none,
  author: none,
  body
) = {
  // Bật font Euler cho công thức toán học
  show math.equation: set text(font: "New Computer Modern Math",size: 10pt)

  // Cấu hình trang (Lề trái phải x: 1.5cm)
  set page(
    paper: "a4",
    margin: (x: 1.5cm, y: 2cm),
    header: context {
      let current-page = here().page()
      
      // Ẩn thanh ngang (header) ở trang bìa
      if title != none and current-page == 1 {
        return none
      }

      let page-num = counter(page).display("1")
      let elems = query(heading.where(level: 1))
      
      let active-h1 = none
      let on-page = elems.filter(e => e.location().page() == current-page)
      
      if on-page.len() > 0 {
        active-h1 = on-page.first()
      } else {
        let before-page = elems.filter(e => e.location().page() < current-page)
        if before-page.len() > 0 {
          active-h1 = before-page.last() 
        }
      }
      
      let current-title = if active-h1 != none { active-h1.body } else { [] }
      
      let current-num = if active-h1 != none and active-h1.numbering != none { 
        let n = counter(heading).at(active-h1.location()).first()
        [#text(fill: color-thm)[§#n] #h(0.3em)]
      } else { [] }
      
      grid(
        columns: (1fr, auto),
        align(left)[*#current-num#text(fill: black)[#current-title]*],
        align(right)[*#page-num*]
      )
      v(-0.5em)
      line(length: 100%, stroke: 0.5pt)
    },
    numbering: "1"
  )
  
  // Cấu hình văn bản toàn cục
  set text(font: "New Computer Modern", size: 10pt, lang: "vi")
  set par(justify: true, leading: 1.4em, spacing: 1.2em)

  // Cấu hình đánh số heading 
  set heading(numbering: "1.1")

  // Tùy biến Mục lục
  show outline.entry.where(level: 1): it => {
    v(1em, weak: true)
    text(fill: color-text, weight: "bold")[#it]
  }
  show outline.entry.where(level: 2): it => {
    text(fill: color-text)[#it]
  }
  
  // Cấu hình lại giao diện Heading
  show heading.where(level: 1): it => {
    thm-counter.update(0) 
    block(above: 1.5em, below: 1em)[
      #if it.numbering != none {
        text(fill: color-thm, size: 15pt)[*§ #counter(heading).display()*]
        h(0.3em)
      }
      #text(fill: black, size: 15pt)[*#it.body*]
    ]
  }
  
  show heading.where(level: 2): it => {
    block(above: 1.2em, below: 0.8em)[
      #if it.numbering != none {
        text(fill: color-thm, size: 12pt)[*§#counter(heading).display()*]
        h(0.3em)
      }
      #text(fill: black, size: 12pt)[*#it.body*]
    ]
  }

  // ==========================================
  // TẠO TRANG BÌA
  // =========================================
  body
}

// ==========================================
// HÀM TẠO BOX ĐỊNH lí, BỔ ĐỀ, BÀI TOÁN
// ==========================================
#let math-box(title: none, prefix: "", color: black, bg: white, body) = {
  thm-counter.step()
  context {
    let ch = counter(heading.where(level: 1)).get().first()
    let thm = thm-counter.get().first()
    let num = str(ch) + "." + str(thm)
    
    let header = text(fill: color, weight: "bold")[#prefix #num]
    if title != none {
      header += text(fill: color, weight: "bold")[ (#title)]
    }
    
     block(
      fill: bg,
      width: 100%,
      inset: (top: 10pt, bottom: 10pt, left: 12pt, right: 12pt),
      spacing: 1.2em,
      radius: 0pt,
      stroke: (left: 3pt + color),
      breakable: true,
      [
        #set par(justify: true, leading: 1.4em) // Ép căn đều bên trong Box
        #header
        #v(0.4em, weak: true) 
        #body
      ]
    )
  }
}
#set text(size: 13pt)
#show math.equation: set text(size: 9pt)
#let y(label) = block(above: 10pt, below: 7pt)[
  #text(size: 9pt, weight: "bold")[#label)]
]
#let menhde(title: none, body) = math-box(title: title, prefix: "Mệnh đề", color: color-prop, bg: bg-prop, body)
#let dinhly(title: none, body) = math-box(title: title, prefix: "Định lí", color: color-thm, bg: bg-thm, body)
#let bode(title: none, body) = math-box(title: title, prefix: "Bổ đề", color: color-lem, bg: bg-lem, body)
#let baitoan(title: none, body) = math-box(title: title, prefix: "Bài toán", color: color-prob, bg: bg-prob, body)
#let dinhnghia(title: none, body) = math-box(title: title, prefix: "Định nghĩa", color: color-def, bg: bg-def, body)
#let ly-thuyet(body) = block(
  width: 100%,
  breakable: true,
  inset: 10pt,
  stroke: 0.7pt + rgb("#777777"),
)[#body]

#let vidu(title: none, body) = math-box(title: title, prefix: "Ví dụ", color: color-ex, bg: bg-ex, body)

#let chungminh(body) = block(spacing: 1.2em, width: 100%)[
  #set par(justify: true, leading: 1.4em) // Ép căn đều bên trong Chứng minh
  #text(fill: color-text, weight: "bold")[Chứng minh.] #body #h(1fr) $square$
]

#let loigiai(body) = block(spacing: 1.2em, width: 100%)[
  #set par(justify: true, leading: 1.4em) // Ép căn đều bên trong Lời giải
  #text(fill: color-text, weight: "bold")[Lời giải.] #body #h(1fr) $square$
]
#let cau(title: none, body) = math-box(title: title, prefix: "Bài", color: color-cau, bg: bg-cau, body)
#let baitap(num: "", body) = block(spacing: 1.2em, width: 100%)[
  #set par(justify: true, leading: 1.4em) // Ép căn đều bên trong Bài tập
  #text(fill: color-text, weight: "bold")[Bài tập #num.] #body
]

// ==========================================
// BẮT ĐẦU NỘI DUNG VĂN BẢN
// ==========================================

#show: template.with(
  title: "Xác Suất",
  subtitle: "HCMUS",
  author: "Khương"
)

//
#include "bia_xac_suat_typst/bia_xac_suat.typ"

#pagebreak()

// Khôi phục định dạng trang cho nội dung chính
#set page(
  paper: "a4",
  margin: (x: 1.5cm, y: 2cm),
  numbering: "1",
)

// Phần nội dung tài liệu
#outline(title: "Mục lục")

#pagebreak()

// Gọi lại Mục lục ở đây 

= Không gian đo - Không gian xác suất

== Xác suất cổ điển

=== Dạng 1. Xác định không gian mẫu

#ly-thuyet[ Ta cần xác định phép thử và kết quả của phép thử.
]
#baitoan[
Một thí nghiệm bao gồm việc thực hiện 20 quan sát về chất lượng của chip máy tính. Mỗi quan sát được ghi nhận là G hay D. Tìm không gian mẫu $S$ của thí nghiệm này. Có bao nhiêu biến cố sơ cấp trong $S$? Đặt $A_n$, $n = 0, dots, 20$ là biến cố có đúng $n$ quan sát loại G được thực hiện. Hỏi $A_n$ có bao nhiêu phần tử?
]

#loigiai[
Mỗi phép quan sát nhận một trong hai giá trị $G,D$. Do đó, không gian mẫu là $S = {G,D}^20 = {(x_1, dots, x_20): x_i in {G,D}}$ và $|S|=2^20$. Để có đúng $n$ quan sát loại $G$, ta chọn $n$ vị trí trong 20 vị trí, suy ra
$
|A_n| = binom(20,n), quad n=0,1,dots,20.
$
]

#baitoan[
Một thí nghiệm bao gồm 10 phép đo $w_1, dots, w_10$ trọng lượng của các gói. Tất cả các gói có trọng lượng từ 10 đến 20 kg. Tìm không gian mẫu $S$. Đặt
$
A = {(w_1, dots, w_10): w_1 + w_2 = 25}, quad
B = {(w_1, dots, w_10): w_1 + w_2 ≤ 25}.
$
Mô tả các biến cố bằng hình vẽ.
]

#loigiai[
Do mọi trọng lượng nằm trong đoạn $[10,20]$, không gian mẫu là $S=[10,20]^10$. Hai biến cố được xác định bởi $A={w in S: w_1+w_2=25}$ và $B={w in S: w_1+w_2≤25}$. Trên mặt phẳng tọa độ $(w_1,w_2)$, miền cơ sở là hình vuông $[10,20]^2$; $A$ là đoạn thẳng nối $(10,15)$ với $(15,10)$, còn $B$ là miền tam giác đóng có các đỉnh $(10,10)$, $(10,15)$, $(15,10)$. Tám tọa độ còn lại nhận giá trị bất kỳ trong $[10,20]$.

#align(center)[#image(bytes("<svg xmlns='http://www.w3.org/2000/svg' width='460' height='300' viewBox='0 0 460 300'><rect width='460' height='300' fill='white'/><path d='M80 30 V250 H320' fill='none' stroke='#252525' stroke-width='2'/><path d='M80 30 H300 V250 H80 Z' fill='#f6f6f6' stroke='#666' stroke-width='1.5'/><polygon points='80,250 80,140 190,250' fill='#dbeafe' stroke='none'/><line x1='80' y1='140' x2='190' y2='250' stroke='#c0392b' stroke-width='3'/><g font-family='sans-serif' font-size='15' fill='#222'><text x='70' y='269'>10</text><text x='181' y='269'>15</text><text x='292' y='269'>20</text><text x='55' y='254'>10</text><text x='55' y='144'>15</text><text x='55' y='34'>20</text><text x='322' y='253'>w1</text><text x='63' y='21'>w2</text><text x='98' y='219' fill='#144b7e'>B</text><text x='183' y='174' fill='#b12d1a'>A: w1 + w2 = 25</text></g></svg>"), format: "svg", width: 70%)]
]

#baitoan[
Xét các chuỗi tín hiệu chiều dài 30 gồm các ký tự nhị phân 0, 1. Mô tả không gian mẫu. Cho $A_10$ là biến cố mà 10 tín hiệu truyền đầu tiên là 1, tìm số phần tử của $A_10$. Cho $B_10$ là biến cố truyền có đúng 10 tín hiệu là 1, tìm số phần tử của $B_10$.
]

#loigiai[
Mỗi tín hiệu có hai khả năng $0$ hoặc $1$, nên $S={0,1}^30$ và $|S|=2^30$. Với $A_10$, mười tín hiệu đầu đã cố định bằng $1$, còn 20 tín hiệu sau tùy ý, do đó $|A_10|=2^20$. Với $B_10$, chọn 10 trong 30 vị trí để đặt tín hiệu $1$, suy ra
$
|B_10|=binom(30,10).
$
]

=== Dạng 2. Tính xác suất của biến cố

#ly-thuyet[Ta cần xác định: (1) phép thử, (2) định nghĩa của xác suất trên không gian mẫu, (3) biến cố và (4) tính xác suất của biến cố.
]
#baitoan[
Xét 1 xúc xắc cân bằng. Tung xúc xắc 2 lần. Tính xác suất để tổng số nút xuất hiện là 10.
]

#loigiai[
Vì xúc xắc cân bằng và hai lần tung độc lập, $S={1,dots,6}^2$ có $36$ kết quả đồng khả năng. Gọi $A$ là biến cố tổng bằng $10$, khi đó $A={(4,6),(5,5),(6,4)}$. Vậy $P(A)=3/36=1/12$.
]

#baitoan[
Một khối tín hiệu 100 bit được truyền đi, xác suất của một bit bị lỗi là $10^(-3)$. Biết khả năng các bit bị lỗi là độc lập nhau. Tính xác suất để khối tín hiệu đó có ít nhất 3 lỗi.
]

#loigiai[
Gọi $K$ là số bit lỗi. Do 100 bit độc lập, $K$ có phân phối nhị thức với $n=100$, $p=0.001$:
$
P(K=k)=binom(100,k)(0.001)^k(0.999)^(100-k).
$
Sử dụng biến cố đối,
$
P(K≥3)&=1-P(K=0)-P(K=1)-P(K=2) \\
&=1-(0.999)^100-100(0.001)(0.999)^99 \\
&quad-binom(100,2)(0.001)^2(0.999)^98.
$
]

#baitoan[
Một cây que được bẻ ngẫu nhiên thành 3 khúc. Tính xác suất để 3 khúc đó tạo thành 1 tam giác.
]

#loigiai[
Giả sử hai điểm bẻ được chọn độc lập, đều trên chiều dài que chuẩn hóa bằng $1$. Gọi $U,V$ là hai vị trí bẻ, $S=(0,1)^2$ và các cặp $(U,V)$ phân bố đều. Ba đoạn có độ dài $min(U,V)$, $|U-V|$, $1-max(U,V)$. Ba đoạn tạo thành tam giác khi và chỉ khi mỗi đoạn nhỏ hơn $1/2$. Trên nửa hình vuông $0<U<V<1$, điều kiện trở thành
$
U<1/2, quad V>1/2, quad V-U<1/2.
$
Miền này là tam giác có diện tích $1/8$. Do tính đối xứng qua đường $U=V$, tổng diện tích là $2(1/8)=1/4$. Vậy $P("tạo thành tam giác")=1/4$. Kết quả dựa trên mô hình chọn hai điểm bẻ đều và độc lập; nếu cách bẻ ngẫu nhiên khác đi thì xác suất có thể thay đổi.
]

=== Dạng 3. Tính xác suất có điều kiện

#ly-thuyet[Ta cần dùng công thức $P(A ∩ B) = P(A) P(B | A)$. Nếu $A, B$ độc lập thì $P(A ∩ B) = P(A) P(B)$.

Ta cũng sử dụng công thức xác suất toàn phần: Cho $B_1, dots, B_n$ là một phân hoạch (bộ biến cố đầy đủ) của $Omega$. Khi đó
$
P(A) = sum_(j=1)^n P(B_j) P(A | B_j).
$
]
#baitoan[
Một máy dùng để kiểm tra tình trạng lỗi của 1 món hàng ($G$ là biến cố tốt, $D$ là biến cố lỗi). Gọi $A$ là biến cố món hàng được xem là tốt sau khi kiểm tra. Cho
$
P(A | G) = 0.95, quad P(A | D) = 0.1, quad P(G) = 0.99.
$
Tìm xác suất của $D$ khi biết $A$.
]

#loigiai[
Đặt $D=G^c$ là biến cố hàng lỗi, suy ra $P(D)=0.01$. Theo công thức Bayes,
$
P(D|A)&=(P(A|D)P(D))/(P(A|G)P(G)+P(A|D)P(D)) 
&=(0.1 dot 0.01)/(0.95 dot 0.99+0.1 dot 0.01)=0.001/0.9415.
$
]

#baitoan[
Hai nhà sản xuất $X, Y$ cung cấp tấm gốm cho một công ty để sản xuất vi mạch. Tỉ lệ tấm gốm hỏng của nhà sản xuất $X$ là 0.01. Tỉ lệ tấm gốm hỏng của nhà sản xuất $Y$ là 0.03. Kiểm tra một lô hàng 200 tấm gốm ở công ty thì thấy có 3 tấm bị hỏng. Lấy một tấm gốm và phát hiện nó bị hỏng. Dự đoán xem tấm gốm này có thể của nhà sản xuất $X$ hay $Y$?
]

#loigiai[
Gọi $D$ là biến cố tấm gốm bị hỏng và $q=P(X)$ là tỉ lệ nguồn $X$ trong lô. Theo xác suất toàn phần,
$
P(D)=0.01q+0.03(1-q)=0.03-0.02q.
$
Nếu dùng tần suất quan sát $3/200=0.015$ để *ước lượng* xác suất hỏng của lô, thì $0.015=0.03-0.02q$, suy ra $q=0.75$. Khi đó Bayes cho ước lượng
$
P(X|D)=(0.01 dot 0.75)/(0.015)=1/2, quad P(Y|D)=1/2.
$
Vậy theo cách ước lượng này, hai nguồn có khả năng ngang nhau. *Lưu ý:* Đề không cho tỉ lệ cung cấp của từng nguồn; số liệu 3/200 chỉ là mẫu quan sát. Vì vậy không thể xác định chính xác xác suất hậu nghiệm hoặc kết luận chắc chắn nguồn gốc nếu không thêm giả thiết.
]

#baitoan[
Một phép thử TT vi khuẩn E-coli gọi là dương tính sai nếu trong mẫu thử không có E-coli nhưng phép thử khẳng định có E-coli, âm tính sai nếu trong mẫu thử có E-coli nhưng phép thử khẳng định không có E-coli. Giả sử thử 10.000 mẫu thịt đã nhiễm E-coli thì phép thử báo có 9.500 mẫu nhiễm; 10.000 mẫu không nhiễm E-coli thì phép thử báo có 9.900 mẫu không nhiễm.

*a)* Độ nhạy (sentivity) của phép thử TT là tỷ lệ dương tính đúng, độ đặc hiệu (specificity) của phép thử TT là tỷ lệ âm tính sai. Tìm độ nhạy và độ đặc hiệu của phép thử E-coli.

*b)* Cho một số mẫu thịt biết có tỷ lệ nhiễm E-coli thực sự là 4.5%. Hỏi nếu chỉ dùng phép thử TT ta có thể khẳng định bao nhiêu % thịt thực sự bị nhiễm?
]

#loigiai[
Gọi $I$ là biến cố thịt nhiễm E-coli và $+$ là kết quả xét nghiệm dương tính.

*a)* Độ nhạy $P(+|I)=9500/10000=0.95$; độ đặc hiệu theo định nghĩa chuẩn là $P(-|I^c)=9900/10000=0.99$. Do đó tỉ lệ âm tính sai $P(-|I)=0.05$ và dương tính sai $P(+|I^c)=0.01$. *Lưu ý:* Câu chữ trong đề gọi độ đặc hiệu là "tỉ lệ âm tính sai", không khớp với định nghĩa chuẩn của độ đặc hiệu.

*b)* Với $P(I)=0.045$, nếu câu hỏi là tỉ lệ mẫu *thực sự nhiễm khi xét nghiệm dương tính*, dùng Bayes:
$
P(I|+)=(P(+|I)P(I))/(P(+|I)P(I)+P(+|I^c)P(I^c))=(0.95 dot 0.045)/(0.95 dot 0.045+0.01 dot 0.955) approx 0.8174.
$
Vậy khoảng $81.74%$ các kết quả dương tính là thực sự nhiễm. Nếu hỏi tỉ lệ *được xét nghiệm báo nhiễm* trong tất cả mẫu, kết quả là $P(+)=0.0523=5.23%$.
]

#baitoan[
Một câu lạc bộ sách phân loại thành viên thành 3 loại: đọc nhiều, đọc vừa và đọc ít và tách các thông báo gửi cho ba nhóm khác nhau. Theo thống kê, có 20% thành viên là loại đọc nhiều; 30% đọc vừa và 50% đọc ít. Một thành viên chỉ được phân loại vào các nhóm sau 18 tháng gia nhập câu lạc bộ, tuy nhiên số liệu mua sách của 3 tháng đầu được dùng để phân loại. Bảng sau cho biết tỉ lệ phần trăm sách mà các thành viên đã được phân loại mua trong các tháng 0, 1, 2 và từ 3 tháng trở lên.

#table(
  columns: 4,
  align: center,
  [Thời gian], [Đọc nhiều (%)], [Đọc vừa (%)], [Đọc ít (%)],
  [0], [5], [15], [60],
  [1], [10], [30], [20],
  [2], [30], [40], [15],
  [3+], [55], [15], [5],
)

Nếu một thành viên chưa mua sách trong 3 tháng đầu thì khả năng thành viên này nằm trong nhóm đọc ít là bao nhiêu?
]

#loigiai[
Gọi $N,V,I$ lần lượt là nhóm đọc nhiều, vừa, ít; $T$ là biến cố chưa mua sách trong ba tháng đầu (hàng $0$ của bảng). Theo xác suất toàn phần,
$
P(T)=0.05 dot 0.2+0.15 dot 0.3+0.60 dot 0.5=0.355.
$
Áp dụng Bayes,
$
P(I|T)=(P(T|I)P(I))/(P(T))=(0.60 dot 0.50)/(0.355)=60/71 approx 0.8451.
$
]

#baitoan[
Một công ty cho vay tài chính có tỷ lệ khách hàng không hoàn thành trả nợ là 1%. Công ty kiểm tra về tín dụng của các khách hàng. Với khách hàng không hoàn thành trả nợ công ty phát hiện 30% có rủi ro tín dụng thấp, 40% rủi ro vừa, 30% rủi ro cao. Với khách hàng hoàn thành trả nợ công ty phát hiện 10% có rủi ro tín dụng thấp, 40% rủi ro vừa, 50% rủi ro cao. Tìm xác suất để một khách hàng rủi ro thấp hoàn thành trả nợ.
]

#loigiai[
Gọi $N$ là biến cố không trả nợ, $H=N^c$ là trả nợ và $T$ là mức rủi ro thấp. Ta có $P(N)=0.01$, $P(H)=0.99$, $P(T|N)=0.30$, $P(T|H)=0.10$. Theo Bayes,
$
P(H|T)&=(P(T|H)P(H))/(P(T|H)P(H)+P(T|N)P(N)) \\
&=(0.10 dot 0.99)/(0.10 dot 0.99+0.30 dot 0.01)=33/34 approx 0.9706.
$
]

#baitoan[
Tất cả những người tham gia khóa học “bỏ hút thuốc” mà vẫn không hút thuốc trong suốt khoảng thời gian một năm sau được mời dự tiệc liên hoan. Trong số nữ tham gia khóa học, có 48% được mời và trong số nam tham gia khóa học có 37% được mời. Nếu 62% số người tham gia lớp học ban đầu là nam, tính

*a)* Tỷ lệ phần trăm của lớp học ban đầu tham gia bữa tiệc.

*b)* Tỷ lệ phần trăm những người tham dự bữa tiệc là nữ.
]

#loigiai[
Gọi $M,F$ là biến cố nam, nữ; $T$ là biến cố được mời dự tiệc. Có $P(M)=0.62$, $P(F)=0.38$, $P(T|M)=0.37$, $P(T|F)=0.48$.

*a)* Theo xác suất toàn phần,
$
P(T)=0.62 dot 0.37+0.38 dot 0.48=0.4118=41.18%.
$
*b)* Theo Bayes,
$
P(F|T)=(P(T|F)P(F))/(P(T))=(0.48 dot 0.38)/(0.4118)=912/2059 approx 0.443.
$
]

#baitoan[
Trong một trường cao đẳng, có 52% sinh viên là nữ, 5% sinh viên học chuyên ngành khoa học máy tính và 2% sinh viên là nữ học chuyên ngành khoa học máy tính. Chọn ngẫu nhiên một sinh viên. Tính xác suất để

*a)* Sinh viên được chọn là nữ biết rằng sinh viên này học chuyên ngành khoa học máy tính.

*b)* Sinh viên này học chuyên ngành khoa học máy tính biết rằng sinh viên này là nữ.
]

#loigiai[
Gọi $F$ là biến cố sinh viên nữ, $C$ là biến cố học khoa học máy tính. Có $P(F)=0.52$, $P(C)=0.05$, $P(F∩C)=0.02$.

*a)* $P(F|C)=(P(F∩C))/(P(C))=0.02/0.05=0.4$.

*b)* $P(C|F)=(P(F∩C))/(P(F))=0.02/0.52=1/26 approx 0.03846$.
]

#baitoan[
Có 15 quả bóng bàn trong một hộp, trong đó có 9 quả bóng chưa từng được sử dụng. Chọn ngẫu nhiên 1 quả bóng để chơi, rồi trả lại hộp. Sau đó, lại chọn ngẫu nhiên 1 quả từ hộp. Tìm xác suất để nhận được quả bóng chưa từng được sử dụng.
]

#loigiai[
Gọi $A$ là biến cố lần thứ hai lấy được bóng chưa từng sử dụng, $B$ là biến cố lần đầu lấy bóng chưa từng sử dụng. Ta có $P(B)=9/15$ và $P(B^c)=6/15$. Nếu lần đầu lấy bóng mới thì sau khi chơi chỉ còn 8 bóng mới; nếu lần đầu lấy bóng cũ thì vẫn còn 9 bóng mới. Theo xác suất toàn phần,
$
P(A)=(9/15)(8/15)+(6/15)(9/15)=126/225=14/25=0.56.
$
]

#baitoan[
Xét 2 cái hộp chứa đá cẩm thạch, hộp thứ nhất chứa 1 viên đá cẩm thạch đen và 1 viên đá cẩm thạch trắng, hộp thứ hai chứa 2 viên đá cẩm thạch đen và 1 viên đá cẩm thạch trắng. Chọn ngẫu nhiên một hộp, và từ hộp đó lấy ra 1 viên đá cẩm thạch. Tính xác suất để nhận được viên đá cẩm thạch đen. Xác suất để hộp thứ nhất là hộp được chọn, biết rằng viên đá cẩm thạch nhận được có màu trắng.
]

#loigiai[
Gọi $H_1,H_2$ là hai hộp được chọn, $D,W$ là viên bi đen và trắng. Có $P(H_1)=P(H_2)=1/2$, $P(D|H_1)=1/2$, $P(D|H_2)=2/3$.

Theo xác suất toàn phần,
$
P(D)=(1/2)(1/2)+(1/2)(2/3)=7/12.
$
Vì $P(W|H_1)=1/2$, $P(W|H_2)=1/3$, theo Bayes,
$
P(H_1|W)=((1/2)(1/2))/((1/2)(1/2)+(1/2)(1/3))=3/5.
$
]

#baitoan[
Một hộp chứa 6 quả bóng trắng và 9 quả bóng đen. Lần lượt lấy ra, không hoàn lại, 4 quả bóng. Tính xác suất để được 2 quả đầu là trắng và 2 quả sau là đen.
]

#loigiai[
Vì các lần lấy không hoàn lại, xác suất được theo thứ tự trắng, trắng, đen, đen là
$
P=(6/15)(5/14)(9/13)(8/12)=6/91.
$
]

#baitoan[
Giả sử xác suất sinh được trai hay gái của một cặp vợ chồng là như nhau và giới tính các người con của họ là độc lập. Một cặp vợ chồng có 5 người con, tính xác suất để

*a)* Tất cả các đứa trẻ đều có cùng giới tính.

*b)* 3 người con lớn nhất là nam, 2 người con còn lại là nữ.

*c)* Có đúng 3 người con trai.

*d)* 2 người con lớn tuổi là nữ.

*e)* Có ít nhất 1 nữ.
]

#loigiai[
Do giới tính các con độc lập, mỗi chuỗi năm lần sinh có xác suất $(1/2)^5=1/32$.

*a)* Có hai chuỗi cùng giới tính (toàn nam hoặc toàn nữ): $P=2/32=1/16$.

*b)* Chỉ có một chuỗi thứ tự phù hợp: $P=1/32$.

*c)* Chọn ba trong năm vị trí là nam: $P=binom(5,3)/32=5/16$.

*d)* Hai người lớn tuổi nhất là nữ: $P=(1/2)^2=1/4$.

*e)* Lấy biến cố đối toàn nam: $P=1-(1/2)^5=31/32$.
]

#baitoan[
An và Bình chơi một trò chơi đối kháng nhiều lần. Khả năng thắng của mỗi lần chơi là độc lập, trong đó xác suất thắng của An là $p$ và của Bình là $1-p$. Họ sẽ dừng chơi khi tổng số ván thắng của một trong hai người chơi là lớn hơn hai ván so với người kia. Người chơi có số ván nhiều hơn sẽ được tuyên bố là người thắng cuộc.

*a)* Tìm xác suất để tổng số ván chơi là 4.

*b)* Tìm xác suất để An là người thắng cuộc.
]

#loigiai[
Đặt $q=1-p$. Khi chưa dừng, độ chênh lệch số ván thắng biến đổi mỗi lượt $+1$ với xác suất $p$, hoặc $-1$ với xác suất $q$. Trò chơi kết thúc khi độ chênh đạt $+2$ hoặc $-2$.

*a)* Để kết thúc đúng ván 4, sau hai ván đầu phải hòa $1-1$ (xác suất $2p q$), rồi An hoặc Bình phải thắng liên tiếp hai ván (xác suất $p^2+q^2$). Do đó
$
P(N=4)=2p q(p^2+q^2).
$
*b)* Gọi $h$ là xác suất An thắng chung cuộc từ trạng thái hòa. Sau hai ván, An thắng ngay với xác suất $p^2$; Bình thắng ngay với xác suất $q^2$; hoặc hai người lại hòa với xác suất $2p q$. Bởi vậy $h=p^2+2p q h$, suy ra
$
h=p^2/(1-2p q)=p^2/(p^2+q^2)=p^2/(p^2+(1-p)^2).$
]

#baitoan[
Một cửa hàng lắp ráp máy tính nhận một loại linh kiện từ ba nguồn $A, B$ và $C$ với tỷ lệ cung cấp lần lượt là 35%, 45% và 20%. Tỷ lệ linh kiện hỏng của các nguồn $A, B$ và $C$ lần lượt là 0.1%, 0.5% và 1%. Nếu một linh kiện chọn ngẫu nhiên tại cửa hàng là linh kiện hỏng, tính xác suất để linh kiện này là do nguồn $A$ cung cấp.
]

#loigiai[
Gọi $D$ là biến cố linh kiện hỏng. Theo xác suất toàn phần,
$
P(D)=0.35 dot 0.001+0.45 dot 0.005+0.20 dot 0.01=0.0046.
$
Theo Bayes,
$
P(A|D)=(P(D|A)P(A))/(P(D))=(0.001 dot 0.35)/(0.0046)=7/92 approx 0.07609.
$
]

#baitoan[
Một công ty bảo hiểm phân loại khách hàng theo ba loại: rủi ro thấp, rủi ro trung bình và rủi ro cao. Báo cáo của công ty cho thấy rằng xác suất một người rơi vào rủi ro thấp, trung bình và cao bị tai nạn trong khoảng thời gian 1 năm lần lượt là 0.05, 0.15 và 0.30. Biết rằng công ty có 20% tổng số khách hàng là rủi ro thấp, 50% là rủi ro trung bình và 30% là rủi ro cao. Tính tỷ lệ khách hàng công ty bị tai nạn trong một năm. Nếu một khách hàng của công ty không bị tai nạn trong năm, thì xác suất để người này là rủi ro thấp hoặc rủi ro trung bình là bao nhiêu?
]

#loigiai[
Gọi $T,V,C$ là các nhóm rủi ro thấp, trung bình, cao; $D$ là biến cố xảy ra tai nạn. Theo xác suất toàn phần,
$
P(D)=0.20 dot 0.05+0.50 dot 0.15+0.30 dot 0.30=0.175.
$
Vậy tỷ lệ khách hàng bị tai nạn là $17.5%$. Vì $P(D^c)=0.825$, nên
$
P((T∪V)|D^c)&=(P(D^c|T)P(T)+P(D^c|V)P(V))/(P(D^c)) \\
&=(0.95 dot 0.20+0.85 dot 0.50)/(0.825)=41/55 approx 0.74545.
$
]

=== Dạng 4. Chứng minh một số công thức

#ly-thuyet[ Ta sử dụng các tiên đề của độ đo xác suất, công thức $P(A ∩ B) = P(A | B) P(B)$ và tính độc lập.
]
#baitoan[
Cho biến cố $A$. Chứng minh
$
P(A^c) = 1-P(A).
$
]

#loigiai[
Vì $A∩A^c=∅$ và $A∪A^c=Omega$, theo tính cộng tính hữu hạn,
$
1=P(Omega)=P(A)+P(A^c).
$
Suy ra $P(A^c)=1-P(A)$.
]

#baitoan[
Cho biến cố $A, B$. Chứng minh
$
P(A^c ∩ B) = P(B) - P(A ∩ B).
$
]

#loigiai[
Ta có phân hoạch rời nhau $B=(A∩B)∪(A^c∩B)$. Theo tính cộng tính,
$
P(B)=P(A∩B)+P(A^c∩B).
$
Suy ra $P(A^c∩B)=P(B)-P(A∩B)$.
]

#baitoan[
Cho $A, B$ là hai biến cố. Biểu diễn $P(A^c ∪ B^c)$, $P(A ∩ B^c)$ và $P(A^c ∩ B)$ theo $P(A)$, $P(B)$, $P(A ∩ B)$.
]

#loigiai[
Theo định luật De Morgan và công thức xác suất hợp, ta có
$
P(A^c ∪ B^c)&=1-P(A∩B),\\
P(A∩B^c)&=P(A)-P(A∩B),\\
P(A^c∩B)&=P(B)-P(A∩B).
$
]

#baitoan[
Cho biến cố $A, B$ với $P(A)=3/4$, $P(B)=1/3$. Chứng minh
$
1/12 ≤ P(A ∩ B) ≤ 1/3.
$
]

#loigiai[
Do $A∩B ⊂ B$ nên $P(A∩B)≤P(B)=1/3$. Mặt khác, $P(A∪B)≤1$ và $P(A∪B)=P(A)+P(B)-P(A∩B)$, nên
$
P(A∩B)≥P(A)+P(B)-1=3/4+1/3-1=1/12.
$
Vậy $1/12≤P(A∩B)≤1/3$.
]

#baitoan[
Cho $A, B$ là hai biến cố với $P(B)>0$. Chứng minh rằng
$
P(A^c | B) = 1-P(A | B).
$
]

#loigiai[
Do $P(B)>0$ và $B=(A∩B)∪(A^c∩B)$ là hợp rời nhau,
$
P(A^c|B)&=(P(A^c∩B))/(P(B))=(P(B)-P(A∩B))/(P(B))\\
&=1-P(A|B).
$
]

#baitoan[
Chứng minh
$
P(A ∩ B ∩ C) = P(A | B ∩ C) P(B | C) P(C),
$
biết $P(B ∩ C)>0$.
]

#loigiai[
Vì $P(B∩C)>0$, ta cũng có $P(C)>0$. Theo định nghĩa xác suất có điều kiện,
$
P(A|B∩C)P(B|C)P(C)&=(P(A∩B∩C))/(P(B∩C)) dot (P(B∩C))/(P(C)) dot P(C)\\
&=P(A∩B∩C).
$
]

#baitoan[
Chứng minh
$
P(A ∪ B) = P(A) + P(B) - P(A ∩ B).
$
Từ đó suy ra công thức tương tự cho $P(A ∪ B ∪ C)$. Tổng quát chứng minh
$
P(∪_(j=1)^n A_j) &= sum_(j=1)^n P(A_j) - sum_(1 ≤ i < j ≤ n) P(A_i ∩ A_j) \\
&+ sum_(1 ≤ i < j < k ≤ n) P(A_i ∩ A_j ∩ A_k) + dots \\
&+ (-1)^(n+1) P(∩_(j=1)^n A_j).
$
]

#loigiai[
Vì $A∪B=A∪(B∖A)$ là hợp rời nhau, nên
$
P(A∪B)=P(A)+P(B∖A)=P(A)+P(B)-P(A∩B).
$
Áp dụng công thức này cho $(A∪B)∪C$ rồi khai triển $(A∪B)∩C=(A∩C)∪(B∩C)$, suy ra
$
P(A∪B∪C)&=P(A)+P(B)+P(C)\\
&quad-P(A∩B)-P(A∩C)-P(B∩C)\\
&quad+P(A∩B∩C).
$
Tổng quát, với mỗi kết quả $omega$ nằm trong đúng $k≥1$ biến cố, tổng hệ số của kết quả đó ở vế phải công thức bao hàm--loại trừ là
$
sum_(r=1)^k (-1)^(r+1)binom(k,r)=1-(1-1)^k=1.
$
Nếu $omega$ không thuộc biến cố nào thì cả hai vế đều bằng $0$. Do đó đẳng thức hàm chỉ thị đúng theo từng $omega$; lấy kỳ vọng (hoặc tích phân) hai vế thu được công thức tổng quát trong đề.
]

#baitoan[
Chứng minh rằng nếu $A, B$ độc lập thì các cặp biến cố $A^c, B$ hay $A^c, B^c$ cũng độc lập.
]

#loigiai[
Giả sử $A,B$ độc lập, nghĩa là $P(A∩B)=P(A)P(B)$. Ta có
$
P(A^c∩B)&=P(B)-P(A∩B)\\
&=P(B)(1-P(A))=P(A^c)P(B).
$
Suy ra $A^c$ và $B$ độc lập. Tiếp tục,
$
P(A^c∩B^c)&=P(A^c)-P(A^c∩B)\\
&=P(A^c)(1-P(B))=P(A^c)P(B^c).
$
Vậy cả hai cặp đều độc lập.
]

#baitoan[
Cho $A_1, dots, A_n$ là các biến cố trong không gian mẫu $Omega$. Giả sử $P(A_1 ∩ dots ∩ A_(n-1))>0$. Chứng minh
$
P(A_1 ∩ dots ∩ A_n) = P(A_1) P(A_2 | A_1) dots P(A_n | A_1 ∩ dots ∩ A_(n-1)).
$
]

#loigiai[
Đặt $C_k=A_1∩dots∩A_k$. Theo giả thiết $P(C_(n-1))>0$; bởi $C_(n-1)⊂C_k$ với $k<n$, nên mọi $P(C_k)>0$. Dùng định nghĩa xác suất có điều kiện,
$
P(C_n)=P(C_(n-1))P(A_n|C_(n-1)).
$
Tiếp tục khai triển $P(C_(n-1))$, ..., $P(C_2)$, cuối cùng được
$
P(A_1∩dots∩A_n)=P(A_1)P(A_2|A_1)dots P(A_n|A_1∩dots∩A_(n-1)).
$
]

#baitoan[
Giả sử $A_1, dots, A_n$ là một họ biến cố đầy đủ của $S$. Chứng minh
$
B = ∪_(j=1)^n (B ∩ A_j)
$
với mọi biến cố $B$. Từ đó suy ra
$
P(B) = sum_(j=1)^n P(B ∩ A_j).
$
]

#loigiai[
Vì họ $A_1,dots,A_n$ là hệ đầy đủ nên $∪_(j=1)^n A_j=S$, đồng thời chúng xung khắc từng đôi. Do đó
$
B=B∩S=B∩(∪_(j=1)^n A_j)=∪_(j=1)^n (B∩A_j).
$
Các biến cố $B∩A_j$ đôi một xung khắc. Theo tính cộng tính hữu hạn,
$
P(B)=sum_(j=1)^n P(B∩A_j).
$
]

#baitoan[
Cho $A, C$ là hai biến cố và $B_1, dots, B_n$ là các biến cố xung khắc từng đôi. Chứng tỏ:

*a)* Nếu $P(A)>0$ thì
$
P((∪_(j=1)^n B_j) | A) = sum_(j=1)^n P(B_j | A).
$

*b)* Nếu họ $B_1, dots, B_n$ đầy đủ, và $P(B_i ∩ C)>0$, $i = 1, dots, n$, thì
$
P(A | C) = sum_(j=1)^n P(B_j | C) P(A | B_j ∩ C).
$

*c)* Nếu $P(A | B_j)=p$ và $P(B_j)>0$ với mọi $j = 1, dots, n$, thì
$
P(A | ∪_(j=1)^n B_j) = p.
$
]

#loigiai[
*a)* Do $B_1,dots,B_n$ xung khắc từng đôi, các tập $B_j∩A$ cũng xung khắc. Với $P(A)>0$,
$
P((∪_(j=1)^n B_j)|A)&=(P(A∩(∪_(j=1)^n B_j)))/(P(A))\\
&=(sum_(j=1)^n P(A∩B_j))/(P(A))=sum_(j=1)^n P(B_j|A).
$
*b)* Nếu họ $B_j$ đầy đủ, các tập $A∩B_j∩C$ đôi một xung khắc, nên
$
P(A|C)&=(sum_(j=1)^n P(A∩B_j∩C))/(P(C))
&=sum_(j=1)^n P(B_j|C)P(A|B_j∩C).
$
*c)* Đặt $D=∪_(j=1)^n B_j$. Khi $B_j$ xung khắc và $P(B_j)>0$,
$
P(A|D)&=(sum_(j=1)^n P(A∩B_j))/(sum_(j=1)^n P(B_j))
&=(sum_(j=1)^n p P(B_j))/(sum_(j=1)^n P(B_j))=p.
$
]

== Không gian xác suất

=== Dạng 1. Kiểm tra các điều kiện của σ-đại số, tìm σ(F)

#ly-thuyet[ Khi cho $cal(F) ⊂ cal(P)(Omega)$, ta tìm các phần tử của $sigma(cal(F))$ bằng cách:

*a)* Bổ sung $Omega$, $∅$.

*b)* Thực hiện các phép toán tập hợp $∩$, $∪$, $∩_(i=i_0)^oo$, $∪_(i=i_0)^oo$ trên $cal(F)$ để suy ra các tập hợp của $sigma(cal(F))$.
]
#baitoan[
Cho $X = {a}$. Hỏi $cal(P)(X)$ là gì? Liệt kê các $sigma$-đại số trên $X$. Tương tự với $X = {a,b}$, $X = {a,b,c}$.
]
#loigiai[
  
  *(a)* 
  Có $cal(P(X))={emptyset,{a}}={emptyset,X}$, do đó $cal(F)=cal(P(X))$, vì $cal(F)$ luôn chứa $emptyset$ và $X$. Nên $cal(F)$ là $sigma-"đại số"$ duy nhất trên $X$.
  
  *(b)* Xét $X= {a,b}$, suy ra $
  cal(P(X))=cal(F)_2&={emptyset,X,{a},{b}}
  $, 
  khi đó các $sigma-"đại số"$ trên $X$ là
  $
  cal(F)_1&={emptyset,X}\
  cal(F)_2&={emptyset,X,{a},{b}}\
  $

  *(c)* Xét $X={a,b,c}$, suy ra 
  $
  cal(P(X))={emptyset,X,{a},{b},{c},{a,b},{b,c},{a,c}}
  $
  Do đó, các $sigma-"đại số"$ xác định trên $X$ là :
  $
  cal(F_1)&={emptyset,X}\
  cal(F_2)&={emptyset,X,{a},{b,c}}\
  cal(F_3)&={emptyset,X,{b},{a,c}}\
  cal(F_4)&={emptyset,X,{c},{a,b}}\
  cal(F_5)&={emptyset,X,{a},{b},{c},{a,b},{b,c},{a,c}}
  $
]
#baitoan[
Cho $X = {a,b,c}$. Đặt $A={a}$, $cal(F)={A}$. Hỏi:

*(i)* $cal(F)$ có là $sigma$-đại số không?

*(ii)* Nếu $cal(M)$ là một $sigma$-đại số trên $X$ và $cal(M) ⊃ cal(F)$ thì $cal(M)$ chứa các tập con nào?

*(iii)* Tìm tất cả các $sigma$-đại số chứa $cal(F)$.

*(iv)* $sigma$-đại số nhỏ nhất $sigma(cal(F))$ là gì?

*(v)* Chỉ ra các tập hợp đo được, các tập hợp không đo được theo $sigma(cal(F))$.
]



#loigiai[
  
Cho $X = {a, b, c}$, $A = {a}$ và $cal(F) = {A}$.

*(i)* $cal(F)$ không là một $sigma$-đại số vì $emptyset, X in.not cal(F)$.

*(ii)* Nếu $cal(M)$ là một $sigma$-đại số chứa $cal(F)$ thì $cal(M)$ phải chứa $emptyset, X, {a}$ và $X without {a} = {b, c}$.

*(iii)* Đặt
$ cal(M)_1 = {emptyset, {a}, {b, c}, X}, $
$ cal(M)_2 = cal(P)(X). $
Đây là tất cả các $sigma$-đại số trên $X$ chứa $cal(F)$: nếu $cal(M)$ chứa thêm một tập ngoài $cal(M)_1$, các phép lấy phần bù, giao và hợp sẽ cho ra cả ${b}$ và ${c}$, từ đó $cal(M) = cal(P)(X)$.

*(iv)* Do $cal(M)_1 subset.eq cal(M)_2$, suy ra
$ sigma(cal(F)) = cal(M)_1 inter cal(M)_2 = {emptyset, {a}, {b, c}, X}. $

*(v)* Các tập đo được theo $sigma(cal(F))$ là $emptyset, {a}, {b, c}, X$. Các tập không đo được là ${b}, {c}, {a, b}, {a, c}$.
]

#loigiai[
  
Cho $X = {a, b, c}$. Xét lần lượt ba họ tập hợp.

*(i)* Với $cal(F)_1 = {{a, b}}$, do $X without {a, b} = {c}$ nên
$ sigma(cal(F)_1) = {emptyset, {a, b}, {c}, X}. $
Các $sigma$-đại số chứa $cal(F)_1$ là $sigma(cal(F)_1)$ và $cal(P)(X)$.

*(ii)* Với $cal(F)_2 = {{a, b}, {a}}$, ta có
$ {b} = {a, b} without {a}, quad {c} = X without {a, b}. $
Suy ra cả ba tập đơn điểm đều thuộc $sigma(cal(F)_2)$, nên
$ sigma(cal(F)_2) = cal(P)(X). $
Do đó, $cal(P)(X)$ là $sigma$-đại số duy nhất chứa $cal(F)_2$.

*(iii)* Với $cal(F)_3 = {{a, b}, {c}}$, hai tập đã cho là phần bù của nhau. Vì vậy
$ sigma(cal(F)_3) = {emptyset, {a, b}, {c}, X}. $
Các $sigma$-đại số chứa $cal(F)_3$ cũng chính là $sigma(cal(F)_3)$ và $cal(P)(X)$.
]


#loigiai[
  
Cho $X = {a, b, c, d}$.

*(i)* Với $cal(F)_1 = {{a, b}}$, ta có $X without {a, b} = {c, d}$. Do đó
$ sigma(cal(F)_1) = {emptyset, {a, b}, {c, d}, X}. $
Mọi $sigma$-đại số chứa $cal(F)_1$ ứng với một cách chia nhỏ các khối ${a, b}$ và ${c, d}$. Có đúng bốn $sigma$-đại số như sau:

$ cal(M)_1 = {emptyset, {a, b}, {c, d}, X}, $
$ cal(M)_2 = {emptyset, {a}, {b}, {a, b}, {c, d}, {a, c, d}, {b, c, d}, X}, $
$ cal(M)_3 = {emptyset, {c}, {d}, {c, d}, {a, b}, {a, b, c}, {a, b, d}, X}, $
$ cal(M)_4 = cal(P)(X). $

Từ đó $sigma(cal(F)_1) = cal(M)_1$.

*(ii)* Với $cal(F)_2 = {{a}, {b}}$, ta có
$ {a, b} = {a} union {b}, quad {c, d} = X without {a, b}. $
Ba khối ${a}$, ${b}$ và ${c, d}$ tạo thành một phân hoạch của $X$. Do đó
$ sigma(cal(F)_2) = {emptyset, {a}, {b}, {a, b}, {c, d}, {a, c, d}, {b, c, d}, X} = cal(M)_2. $
Các $sigma$-đại số chứa $cal(F)_2$ là $cal(M)_2$ và $cal(P)(X)$.
]


#loigiai[
  
Nếu $I = emptyset$, theo quy ước $inter.big_(i in I) cal(M)_i = cal(P)(X)$, là một $sigma$-đại số. Xét tiếp trường hợp $I != emptyset$. Đặt $cal(M) = inter.big_(i in I) cal(M)_i$. Ta kiểm tra ba tính chất của $sigma$-đại số.

*(i)* Vì $X in cal(M)_i$ với mọi $i in I$, suy ra $X in cal(M)$.

*(ii)* Lấy $A in cal(M)$. Khi đó $A in cal(M)_i$ với mọi $i in I$. Do mỗi $cal(M)_i$ đóng đối với phép lấy phần bù nên $X without A in cal(M)_i$ với mọi $i in I$. Vậy $X without A in cal(M)$.

*(iii)* Lấy dãy $(A_n)_(n >= 1)$ với $A_n in cal(M)$, $forall n >= 1$. Khi đó $A_n in cal(M)_i$ với mọi $n >= 1$ và $i in I$. Do mỗi $cal(M)_i$ đóng đối với phép hợp đếm được nên
$ union.big_(n=1)^infinity A_n in cal(M)_i, quad forall i in I. $
Suy ra $union.big_(n=1)^infinity A_n in cal(M)$.

Vậy $inter.big_(i in I) cal(M)_i$ là một $sigma$-đại số trên $X$.
]

#loigiai[
  
Cho $X != emptyset$ và
$ cal(M) = {A subset.eq X : A "hoặc" X without A "quá lắm đếm được"}. $

*a)* Chứng minh $cal(M)$ là một $sigma$-đại số.

Vì $X without X = emptyset$ quá lắm đếm được nên $X in cal(M)$.

Nếu $A in cal(M)$ thì $A$ hoặc $X without A$ quá lắm đếm được. Hai tập này đổi vai trò khi lấy phần bù, vì vậy $X without A in cal(M)$.

Lấy một dãy $(A_n)_(n >= 1)$ trong $cal(M)$ và đặt $B = union.big_(n=1)^infinity A_n$.

Nếu mọi $A_n$ đều quá lắm đếm được thì $B$ cũng quá lắm đếm được, suy ra $B in cal(M)$.

Ngược lại, nếu tồn tại $k$ sao cho $X without A_k$ quá lắm đếm được thì
$ X without B subset.eq X without A_k. $
Vậy $X without B$ quá lắm đếm được, suy ra $B in cal(M)$.

Do đó $cal(M)$ là một $sigma$-đại số trên $X$.

Tiếp theo, đặt $cal(C) = {{x} : x in X}$. Vì mỗi ${x}$ là tập hữu hạn nên $cal(C) subset.eq cal(M)$. Theo tính nhỏ nhất của $sigma(cal(C))$, ta có
$ sigma(cal(C)) subset.eq cal(M). $

Ngược lại, lấy $A in cal(M)$. Nếu $A$ quá lắm đếm được thì $A$ là hợp hữu hạn hoặc đếm được của các tập đơn điểm, nên $A in sigma(cal(C))$. Nếu $X without A$ quá lắm đếm được thì $X without A in sigma(cal(C))$, kéo theo $A in sigma(cal(C))$ do tính đóng đối với phép lấy phần bù. Vậy
$ cal(M) subset.eq sigma(cal(C)). $

Kết luận:
$ cal(M) = sigma({{x} : x in X}). $

*b)* Nếu $X$ quá lắm đếm được thì mọi $A subset.eq X$ cũng quá lắm đếm được. Do đó mọi tập con của $X$ đều thuộc $cal(M)$, suy ra
$ cal(M) = cal(P)(X). $

*c)* Giả sử $X = A union B$, với $A inter B = emptyset$ và $A$, $B$ đều không đếm được. Khi đó $A in cal(P)(X)$, nhưng $A$ không quá lắm đếm được và $X without A = B$ cũng không quá lắm đếm được. Suy ra $A in.not cal(M)$, nên
$ cal(M) subset.neq cal(P)(X). $
]

=== Dạng 2. Chứng minh một tập hợp trên ℝ là tập Borel

*Gợi ý lý thuyết.* Ta có $sigma$-đại số Borel $cal(B)(RR^d)$ là $sigma$-đại số nhỏ nhất chứa các tập mở trong $RR^d$.

Các tập mở trên $RR$ bao gồm các khoảng mở $(a,b)$ và các hợp đếm được $∪_(i ∈ J) (a_i, b_i)$ với $J ⊂ NN$. Các tập hợp khác dùng phép toán tập hợp để kiểm tra.

#baitoan[
Cho $a,b∈RR$, $a<b$. Chứng minh rằng các tập hợp
$
(a,oo), quad [a,oo), quad (-oo,b], quad (-oo,b),
$
$
[a,b), quad (a,b], quad [a,b], quad (a,b)
$
là các tập Borel. Tập hợp ${a}$ với $a∈RR$ có phải là tập Borel không?
]
#loigiai[

  Trên $RR$, ta có các tập mở đều là các tập Borel theo định nghĩa, vì vậy $(a,infinity) ,(-infinity,b),(a,b)$ đều là các tập Borel. Xét $[a,infinity)^C=(-infinity,a)$, vì $(-infinity,a)$ là tập Borel, do đó $[a,infinity) in cal(B)(RR)$. Tương tự với $(-infinity,b]$. Xét $[a,b)=[a,infinity) inter (-infinity,b)$, vì cả $2$ tập trên đều là tập Borel, nên giao hữu hạn các tập Borel là tập Borel, do đó $[a,b)$ là tập mở nên $[a,b)$ là tập Borel. Tương tự với $(a,b]$.

  Xét $[a,b]=[a,infinity) inter (-infinity,b]$, vì cả $2$ tập trên đều là tập Borel , nên $[a,b]$ là tập Borel.

  Xét tập ${a},a in RR$ , khi đó, $R backslash {a}= (-infinity,a) union (a, infinity) $. Theo chứng minh trên, ta có ${a}$ là tập đóng nên ${a}$ là tập Borel.
]

#baitoan[
Cho $a,b∈RR$, $a<b$. Cho $cal(F)_0 = {(a,oo): a ∈ RR}$.

*a)* Chứng minh rằng $sigma(cal(F)_0) ⊂ cal(B)(RR)$.

*b)* Cho $cal(M)$ là một $sigma$-đại số trên $RR$ và giả sử $(a,oo) ∈ cal(M)$ với mọi $a∈RR$. Sử dụng đẳng thức
$
[a,oo) = ∩_(n=1)^oo (a-1/n,oo),
$
chứng minh rằng $[a,oo) ∈ cal(M)$. Suy ra $(-oo,b)$, $(-oo,b]$, $(a,b)$, $[a,b)$, $(a,b]$ là các tập hợp trong $cal(M)$. Từ đó suy ra $sigma(cal(F)_0)$ cũng có tính chất như $cal(M)$.

*c)* Cho tập hợp $U$ mở trong $RR$. Lý thuyết tập hợp cho biết: tập hợp các khoảng $I:=(a,b) ⊂ U$ (với $a,b∈QQ$) là đếm được, do đó ta có thể viết các khoảng này dưới dạng dãy $(I_n)$, $n=1,2,dots$. Chứng minh rằng $U = ∪_(n=1)^oo I_n$. Từ đó suy ra $U∈sigma(cal(F)_0)$ với mọi tập mở $U⊂RR$.


*d)* Sử dụng điều trên, chứng minh rằng $sigma(cal(F)_0)=cal(B)(RR)$.
]

#loigiai[

  *a)* Ta có, $sigma(cal(F_(0)))={emptyset,RR,(a,infinity),(-infinity,a]}$. Khi đó, theo bài toán trước, ta đều có các $ A in sigma(cal(F_(0))) => A in cal(B(RR)) $.

  Nên $sigma(cal(F_o))subset cal(B(RR))$.

  *b)* Từ giả thiết, ta có với mỗi $n>=1, (a-1/n,infinity) in cal(M)$. Mà $cal(M)$ đóng với phép giao đếm được, do đó 
  $
  [a,infinity)=inter_(n=1)^infinity (a-1/n,infinity) in cal(M)
  $
  Tương tự, ta có $(-infinity,b)^C=[b,infinity) in cal(M)$ và $(-infinity,b]^C=(b,infinity) in cal(M)$. Có $(a,b)=(a,infinity) inter (b,infinity)$ mà $(a,infinity)$ và $(b,infinity)$ đều $in cal(M)$. Do đó, $(a,b) in cal (M)$, vì $cal(M)$ đóng dưới phép giao đếm được, các ý còn lại tương tự, hơn nữa đặc biệt chọn $cal(M)=sigma(F_(0))$.

  *c)*
]
#baitoan[
Chứng minh rằng $sigma(cal(F)_0)=cal(B)(RR)$ với
$
cal(F)_0 = {[a,oo): a∈RR}.
$
]

#baitoan[
Chứng minh rằng $sigma(cal(F)_0)=cal(B)(RR)$ với
$
cal(F)_0 = {(a,b]: a,b∈RR, a<b}.
$
]

#baitoan[
Chứng minh rằng $sigma(cal(F)_0)=cal(B)(RR)$ với
$
cal(F)_0 = {[a,b]: a,b∈RR, a<b}.
$
]

=== Dạng 3. Các độ đo tổng quát

#ly-thuyet[ Ta sử dụng các tiên đề của độ đo để chứng minh.
]
#baitoan[
Cho $mu_n$ là một dãy các độ đo trong không gian đo được $(X,cal(M))$ và ${a_n}$ là một dãy các số thực không âm. Hỏi
$
mu = sum_(n=1)^oo a_n mu_n
$
có xác định một độ đo dương trên $(X,cal(M))$? Nếu $mu_n$ là các độ đo xác suất và $sum_(n=1)^oo a_n = 1$ thì $mu$ có là độ đo xác suất không?
]
#loigiai[

  Xét $mu =sum_(n=1)^infinity a_n mu _n$, nghĩa là với bất kỳ $A in cal(M)$, ta đều có 
  $
  mu(A)=sum_(n=1)^infinity a_n mu_(n)(A)
  $
  Ta chứng minh $mu$ là một đo đo dương trên $cal(X),cal(M)$, thật vậy

  *(i)* Có với bất kỳ $A in cal(M)$, thì với tùy ý $n>=1$ khi đó $mu_(n) (A) >=0$ do $mu_(n)$ là một dãy các độ đo, hơn nữa do giả thiết $a_n>=0,n>=1$  suy ra 
  $
  mu (A)=sum_(n=1)^infinity a_n u_(n) (A) >=0
  $


  *(ii)* Với $n>=1$, có $mu _(n) (emptyset) =0$, do đó $
  mu(emptyset)=sum_(n=1)^infinity a_n mu_(n)(emptyset)=0
  $

  *(iii)* Xét dãy $(A_k)_ (k>=1) subset.eq cal(M)$ và $A_i != A_j, forall i!=j$, khi đó ta chứng minh
  $
  mu(union_(k=1)^infinity A_k)=sum_(k=1)^infinity mu(A_k)
  $
  Ta có, 
  $
  mu(union_(k=1)^infinity A_k)&=sum_(n=1)^(infinity) a_n mu_(n)(union_(k=1)^infinity A_k)\
  &=sum_(n=1)^infinity a_n sum_(k=1)^infinity mu_(n) (A_k)\
  &=sum_(n=1)^infinity sum_(k=1)^infinity a_n mu_n (A_k)\
  &=sum_(k=1)^infinity sum_(n=1)^infinity a_n
  $
  
]
#baitoan[
Cho $(X,cal(M),mu)$ là một không gian đo, $mu(X)<oo$, và $(A_n)$ là một dãy các tập con đo được trên không gian đo. Đặt
$
lim sup_(n→oo) A_n = ∩_(n=1)^oo ∪_(k=n)^oo A_k, quad
lim inf_(n→oo) A_n = ∪_(n=1)^oo ∩_(k=n)^oo A_k.
$
Chứng minh
$
mu(lim inf_(n→oo) A_n) ≤ lim inf_(n→oo) mu(A_n),
$
$
mu(lim sup_(n→oo) A_n) ≥ lim sup_(n→oo) mu(A_n).
$
]
#loigiai[
  
]
=== Dạng 4. Các độ đo rời rạc từ σ-đại số sinh ra từ một phân hoạch

#ly-thuyet[ Cho $cal(F) ⊂ cal(P)(X)$, $cal(F) = {A_i: i ∈ I}$, trong đó $I ⊂ NN$, $A_i ∩ A_j = ∅$ với $i ≠ j$.

- Nếu $∪_(i ∈ I) A_i = X$ thì ta xây dựng độ đo trên $sigma(cal(F))$ bằng cách đặt $mu(A_i) = p_i ≥ 0$ với $i ∈ I$. Khi đó, nếu $A = ∪_(i ∈ J) A_i$, $J ⊂ I$, thì
  $
  mu(A) = sum_(i ∈ J) p_i.
  $
- Nếu $∪_(i ∈ I) A_i ≠ X$ thì đặt $A_c = X ∖ ∪_(i ∈ I) A_i$, $mu(A_i) = p_i ≥ 0$, $mu(A_c) = p_c ≥ 0$. Khi đó, với $J ⊂ I$,
  $
  mu(∪_(i ∈ J) A_i) = sum_(i ∈ J) p_i,
  $
  $
  mu(A_c ∪ ∪_(i ∈ J) A_i) = p_c + sum_(i ∈ J) p_i.
  $
- Nếu $∪_(i ∈ I) A_i = X$ thì $mu(X) = sum_(i ∈ I) p_i$. Nếu $mu$ là độ đo xác suất thì $sum_(i ∈ I) p_i = 1$.
]
#baitoan[
Cho $X={a,b}$, $mu$ là một hàm trên các tập con của $X$. Cho biết $mu({a})=1/4$ và $mu(X)=1$. Cho biết giá trị của $mu(∅)$, $mu({b})$ để $mu$ là độ đo.
]

#loigiai[
  Có $X={a} union {b}$, do đó để $mu$ là một độ đo trên $X$, thì $mu({emptyset})=0$ và $mu({b})+mu({a})=mu(X)=>mu({b})=3/4$.
]
#baitoan[
Cho $X={a,b,c}$, $cal(F)=cal(P)(X)$. Cho biết $mu$ là một độ đo xác suất trên $cal(F)$ và $mu({a,b})=x$, $mu({b,c})=y$, $mu({c,a})=z$. Tìm điều kiện của $x,y,z$ và tính $mu({a})$, $mu({b})$, $mu({c})$ theo $x,y,z$.
]
#loigiai[
  Có $X={a}union{b}union{c}$ và ${a},{b},{c}$ đôi một rời nhau, do đó $
  mu({a})+mu({b})+mu({c})=mu(X)=1 quad (1)
  $
  Hơn nữa, có $
  mu({a})+mu({b})&=x\
  mu({b})+mu({c})&=y\
  mu({c})+mu({a})&=z\
  
  $
  Do đó, từ $(1)$ thì $x+y+z=1/2$. Hơn nữa, có $mu({a})=x-mu({b})=x-(y-mu({c}))=x-y+mu({c})=x-y+z-mu({a}) => mu({a})=(x-y+z)/2$. Tương tự với $mu({b})$ và $mu({c})$.
  
]
#baitoan[
Cho $X={a,b,c,d}$, cho $mu,nu$ là độ đo xác suất trên $cal(P)(X)$. Cho biết $mu({a})=mu({b})=mu({c})=mu({d})=1/4$ và $nu({b})=nu({d})=1/2$. Cho $cal(G)={∅,X,{a,b},{b,c},{c,d},{d,a}}$.

*a)* $mu(A)=nu(A)$ với $A∈cal(G)$.

*b)* Chứng minh có $A∈sigma(cal(G))$ với $mu(A)≠nu(A)$.
]
#loigiai[
  
  *a)* Vì $nu$ là độ đo xác suất nên
  $
    nu(X) = nu({a}) + nu({b}) + nu({c}) + nu({d}) = 1.
  $
  Mặt khác, $nu({b}) = nu({d}) = 1/2$, suy ra
  $
    nu({a}) + nu({c}) = 0.
  $
  Do tính không âm của độ đo, ta có $nu({a}) = nu({c}) = 0$.

  Xét các trường hợp:

  - Với $A = emptyset$ hoặc $A = X$, hiển nhiên $mu(A) = nu(A)$.
  - Với $A = {a,b}$, ta có
    $
      mu(A) = 1/4 + 1/4 = 1/2
      = 0 + 1/2 = nu(A).
    $
  - Với $A = {b,c}$, ta có
    $
      mu(A) = 1/2 = 1/2 + 0 = nu(A).
    $
  - Với $A = {c,d}$, ta có
    $
      mu(A) = 1/2 = 0 + 1/2 = nu(A).
    $
  - Với $A = {d,a}$, ta có
    $
      mu(A) = 1/2 = 1/2 + 0 = nu(A).
    $

  Vậy $mu(A) = nu(A)$ với mọi $A in cal(G)$.

  *b)* Theo định nghĩa, $sigma(cal(G))$ là $sigma$-đại số nhỏ nhất chứa $cal(G)$.

  Vì ${a,b}, {d,a} in cal(G) subset.eq sigma(cal(G))$ và $sigma(cal(G))$ đóng đối với phép giao hữu hạn nên
  $
    {a,b} inter {d,a} = {a} in sigma(cal(G)).
  $

  Chọn $A = {a}$. Khi đó
  $
    mu(A) = 1/4 != 0 = nu(A).
  $

  Vậy tồn tại $A in sigma(cal(G))$ sao cho $mu(A) != nu(A)$.
]


=== Phân hoạch và cách xây dựng độ đo xác suất

*1. Ý nghĩa của họ $cal(F)$*

Cho $X$ là một tập khác rỗng và $I$ là tập chỉ số. Họ các tập hợp
$
  cal(F) = {A_i : i in I}
$
được gọi là một *phân hoạch* (partition) của $X$ nếu thỏa mãn:

- $A_i != emptyset$ với mọi $i in I$.
- $A_i inter A_j = emptyset$ với mọi $i != j$.
- $union_(i in I) A_i = X$.

Như vậy, $cal(F)$ là một họ các tập con không rỗng, đôi một rời nhau và hợp của chúng bằng $X$.

*Ví dụ.* Cho $X = {1,2,3,4,5,6}$ và
$
  A_0 = {1,2}, quad A_1 = {3,4}, quad A_2 = {5,6}.
$
Khi đó $cal(F) = {A_0,A_1,A_2}$ là một phân hoạch của $X$.

Lưu ý rằng $cal(F)$ không nhất thiết là một $sigma$-đại số. Tuy nhiên, ta có thể xây dựng $sigma$-đại số sinh bởi $cal(F)$, ký hiệu là $sigma(cal(F))$.

Trong ví dụ trên,
$
  sigma(cal(F)) = {
    emptyset, A_0, A_1, A_2,
    A_0 union A_1, A_0 union A_2,
    A_1 union A_2, X
  }.
$

*2. Mệnh đề tổng quát*

Cho $cal(F) = {A_i : i in I}$ là một phân hoạch hữu hạn hoặc đếm được của $X$. Giả sử $(p_i)_(i in I)$ là một họ số thực thỏa mãn
$
  p_i >= 0, quad
  sum_(i in I) p_i = 1.
$

Khi đó tồn tại duy nhất một độ đo xác suất $mu$ trên $sigma(cal(F))$ thỏa mãn
$
  mu(A_i) = p_i, quad forall i in I.
$

*Chứng minh.*

Vì $cal(F)$ là một phân hoạch hữu hạn hoặc đếm được nên mọi tập $B in sigma(cal(F))$ đều biểu diễn được dưới dạng hợp của một số tập $A_i$.

Cụ thể, ta có
$
  sigma(cal(F))
  = { union_(i in J) A_i : J subset.eq I }.
$

Với mỗi $B in sigma(cal(F))$, đặt
$
  J_B = {i in I : A_i subset.eq B}.
$

Ta định nghĩa
$
  mu(B) = sum_(i in J_B) p_i.
$

Ta chứng minh $mu$ là một độ đo xác suất.

*a)* Vì $p_i >= 0$ với mọi $i in I$ nên $mu(B) >= 0$ với mọi $B in sigma(cal(F))$. Ngoài ra, $J_(emptyset) = emptyset$, do đó
$
  mu(emptyset) = 0.
$

*b)* Giả sử $(B_k)_(k >= 1)$ là một dãy các tập đôi một rời nhau thuộc $sigma(cal(F))$.

Do các $A_i$ tạo thành phân hoạch của $X$ nên các tập chỉ số $J_(B_k)$ cũng đôi một rời nhau. Hơn nữa, mọi $p_i$ đều không âm nên ta có thể nhóm lại các số hạng trong tổng:
$
  mu(union_(k=1)^infinity B_k)
  &= sum_(k=1)^infinity
     sum_(i in J_(B_k)) p_i \
  &= sum_(k=1)^infinity mu(B_k).
$

Vậy $mu$ có tính cộng tính đếm được.

*c)* Vì $X = union_(i in I) A_i$ nên
$
  mu(X) = sum_(i in I) mu(A_i)
  = sum_(i in I) p_i = 1.
$

Như vậy, $mu$ là một độ đo xác suất trên $sigma(cal(F))$.

Tính duy nhất được suy ra từ tính cộng tính đếm được: với mọi $B in sigma(cal(F))$, giá trị $mu(B)$ bắt buộc bằng tổng các $mu(A_i)$ ứng với những tập $A_i$ nằm trong $B$.

*Nhận xét.* Mệnh đề trên cho thấy để xây dựng một độ đo xác suất trên $sigma(cal(F))$, ta chỉ cần gán cho mỗi tập $A_i$ một trọng số không âm sao cho tổng các trọng số bằng $1$. Đây là cơ sở chung của các bài toán sau.


#baitoan[
  Cho tập $X$ và một phân hoạch $cal(F) = {A_i : i = 0,1,...,n}$. Chứng minh các độ đo $mu$ sau là độ đo xác suất.

  *a)* $mu$ thỏa
  $
    mu(A_i) = binom(n,i) p^i (1-p)^(n-i),
    quad 0 < p < 1.
  $
  Độ đo $mu$ gọi là độ đo nhị thức. Tính $mu(A_1 union A_2 union A_3)$ với $n = 40$, $p = 0.1$.

  *b)* $mu$ thỏa $mu(A_i) = 1/(n+1)$. Độ đo này gọi là độ đo đều rời rạc.
]

#loigiai[
  *a)* Vì $0 < p < 1$ và $0 <= i <= n$ nên
  $
    mu(A_i) = binom(n,i) p^i (1-p)^(n-i) >= 0.
  $

  Mặt khác, do $cal(F)$ là một phân hoạch của $X$, ta có
  $
    mu(X)
    &= sum_(i=0)^n mu(A_i) \
    &= sum_(i=0)^n binom(n,i) p^i (1-p)^(n-i) \
    &= (p + 1 - p)^n \
    &= 1.
  $

  Trong đó, đẳng thức thứ ba được suy ra từ công thức nhị thức Newton.

  Theo mệnh đề tổng quát, các trọng số đã cho xác định một độ đo xác suất trên $sigma(cal(F))$.

  Với $n = 40$, $p = 0.1$, do các tập $A_1,A_2,A_3$ đôi một rời nhau nên
  $
    mu(A_1 union A_2 union A_3)
    &= sum_(i=1)^3 mu(A_i) \
    &= sum_(i=1)^3 binom(40,i) (0.1)^i (0.9)^(40-i) \
    &= 40 (0.1) (0.9)^39
      + 780 (0.1)^2 (0.9)^38 \
    &quad + 9880 (0.1)^3 (0.9)^37 \
    &approx 0.40835.
  $

  *b)* Vì $n >= 0$ nên
  $
    mu(A_i) = 1/(n+1) > 0.
  $

  Mặt khác,
  $
    mu(X)
    &= sum_(i=0)^n mu(A_i) \
    &= sum_(i=0)^n 1/(n+1) \
    &= (n+1) dot 1/(n+1) = 1.
  $

  Theo mệnh đề tổng quát, các trọng số đã cho xác định một độ đo xác suất trên $sigma(cal(F))$.
]
#baitoan[
  Cho tập $X$ và một phân hoạch đếm được $cal(F) = {A_i : i = 0,1,...}$ của $X$. Chứng minh các độ đo sau là độ đo xác suất.

  *a)* $mu$ thỏa
  $
    mu(A_i) = (e^(-lambda) lambda^i)/(i!),
    quad lambda > 0.
  $
  Độ đo này gọi là độ đo Poisson. Tính $mu(A_1 union A_2 union A_3)$ với $lambda = 2$.

  *b)* $mu$ thỏa
  $
    mu(A_i) = p(1-p)^i,
    quad p in (0,1).
  $
  Độ đo này gọi là độ đo hình học. Tính $mu(A_1 union A_2 union A_3 union A_4)$ với $p = 0.6$.
]

#loigiai[
  *a)* Vì $lambda > 0$ nên
  $
    mu(A_i) = (e^(-lambda) lambda^i)/(i!) >= 0.
  $

  Mặt khác, do $cal(F)$ là một phân hoạch đếm được của $X$, ta có
  $
    mu(X)
    &= sum_(i=0)^infinity mu(A_i) \
    &= sum_(i=0)^infinity (e^(-lambda) lambda^i)/(i!) \
    &= e^(-lambda) sum_(i=0)^infinity lambda^i/(i!) \
    &= e^(-lambda) e^lambda \
    &= 1.
  $

  Đẳng thức thứ tư được suy ra từ khai triển Taylor của hàm mũ:
  $
    e^x = sum_(i=0)^infinity x^i/(i!).
  $

  Theo mệnh đề tổng quát, các trọng số đã cho xác định một độ đo xác suất trên $sigma(cal(F))$.

  Với $lambda = 2$, do các tập $A_1,A_2,A_3$ đôi một rời nhau nên
  $
    mu(A_1 union A_2 union A_3)
    &= sum_(i=1)^3 mu(A_i) \
    &= sum_(i=1)^3 (e^(-2) 2^i)/(i!) \
    &= e^(-2) (2 + 2^2/(2!) + 2^3/(3!)) \
    &= 16/3 e^(-2) \
    &approx 0.72179.
  $

  *b)* Vì $0 < p < 1$ nên
  $
    mu(A_i) = p(1-p)^i >= 0.
  $

  Mặt khác,
  $
    mu(X)
    &= sum_(i=0)^infinity mu(A_i) \
    &= p sum_(i=0)^infinity (1-p)^i \
    &= p dot 1/(1-(1-p)) \
    &= 1.
  $

  Trong đó, đẳng thức thứ ba được suy ra từ công thức tổng cấp số nhân vô hạn:
  $
    sum_(i=0)^infinity q^i = 1/(1-q),
    quad |q| < 1.
  $

  Theo mệnh đề tổng quát, các trọng số đã cho xác định một độ đo xác suất trên $sigma(cal(F))$.

  Với $p = 0.6$, do các tập $A_1,A_2,A_3,A_4$ đôi một rời nhau nên
  $
    mu(A_1 union A_2 union A_3 union A_4)
    &= sum_(i=1)^4 mu(A_i) \
    &= 0.6 sum_(i=1)^4 (0.4)^i \
    &= 0.6 (0.4 + 0.16 + 0.064 + 0.0256) \
    &= 0.38976.
  $
]

=== Dạng 5. Độ đo Lebesgue, Stieltjes trên ℝ

*Gợi ý lý thuyết.* *Độ đo Lebesgue:* Với $a < b$,
$
m((a,b)) = m((a,b]) = m([a,b]) = m([a,b)) = b-a.
$
Ta cũng có $m({a}) = 0$. Nếu $I_j ⊂ RR$, $j = 1, dots, d$, thì
$
m_d(I_1 times dots times I_d) = m(I_1) dots m(I_d).
$
*Độ đo Stieltjes:* Đặt $F(a^+) = lim_(x → a^+) F(x)$, $F(a^-) = lim_(x → a^-) F(x)$ với $F: RR → RR$ là hàm không giảm. Theo công thức trong tài liệu,
$
lambda_F({a}) = F(a^+) - F(a^-), quad lambda_F([a,b]) = F(b^+) - F(a^-).
$

#baitoan[
Cho $F: RR → RR$ là hàm không âm và tăng. Chứng minh
$
lambda_F([a,b)) &= F(b^(-)) - F(a^(+)),\
lambda_F((a,b)) &= F(b^(-)) - F(a^(+)), \
lambda_F((a,b]) &= F(b^(+)) - F(a^(+)), \
lambda_F((-oo,b]) &= F(b^(+)) - lim_(x→-oo) F(x), \
lambda_F((a,+oo]) &= lim_(x→+oo) F(x) - F(a^(+)).
$
]


#loigiai[
  Vì $F: bb(R) -> bb(R)$ là hàm không giảm nên các giới hạn một phía $F(x^-)$ và $F(x^+)$ luôn tồn tại.

  Xét độ đo Lebesgue–Stieltjes $lambda_F$ sinh bởi hàm $F$, với

  $ lambda_F((u,v]) = F(v^+) - F(u^+), quad u < v. $

  *1. Chứng minh công thức trên khoảng $(a,b)$.*

  Chọn $N in bb(N)$ đủ lớn sao cho $b - 1/N > a$.

  Đặt $A_n = (a,b - 1/n]$ với $n >= N$.

  Khi đó, $A_n$ là dãy tập tăng và

  $ union.big_(n >= N) A_n = (a,b). $

  Theo tính liên tục từ dưới của độ đo, ta có

  $
    lambda_F((a,b))
    &= lim_(n -> infinity) lambda_F(A_n) \
    &= lim_(n -> infinity)
       (F((b - 1/n)^+) - F(a^+)) \
    &= F(b^-) - F(a^+).
  $

  *2. Chứng minh công thức trên tập đơn điểm $ {a} $.*

  Đặt $B_n = (a - 1/n,a]$.

  Khi đó, $B_n$ là dãy tập giảm và

  $ inter.big_(n >= 1) B_n = {a}. $

  Vì $lambda_F(B_1) < +infinity$, áp dụng tính liên tục từ trên của độ đo, ta được

  $
    lambda_F({a})
    &= lim_(n -> infinity) lambda_F(B_n) \
    &= lim_(n -> infinity)
       (F(a^+) - F((a - 1/n)^+)) \
    &= F(a^+) - F(a^-).
  $

  *3. Chứng minh công thức trên khoảng $[a,b)$.*

  Vì

  $ [a,b) = {a} union (a,b) $

  và hai tập trên rời nhau nên

  $
    lambda_F([a,b))
    &= lambda_F({a}) + lambda_F((a,b)) \
    &= F(a^+) - F(a^-)
       + F(b^-) - F(a^+) \
    &= F(b^-) - F(a^-).
  $

  *4. Chứng minh công thức trên khoảng $(a,b]$.*

  Theo định nghĩa của độ đo $lambda_F$, ta có ngay

  $
    lambda_F((a,b]) = F(b^+) - F(a^+).
  $

  *5. Chứng minh công thức trên khoảng $(-infinity,b]$.*

  Chọn $N in bb(N)$ sao cho $-N < b$.

  Đặt $C_n = (-n,b]$ với $n >= N$.

  Khi đó, $C_n$ là dãy tập tăng và

  $ union.big_(n >= N) C_n = (-infinity,b]. $

  Theo tính liên tục từ dưới của độ đo,

  $
    lambda_F((-infinity,b])
    &= lim_(n -> infinity) lambda_F(C_n) \
    &= lim_(n -> infinity)
       (F(b^+) - F((-n)^+)) \
    &= F(b^+) - lim_(x -> -infinity) F(x).
  $

  *6. Chứng minh công thức trên khoảng $(a,+infinity)$.*

  Chọn $N in bb(N)$ sao cho $N > a$.

  Đặt $D_n = (a,n]$ với $n >= N$.

  Khi đó, $D_n$ là dãy tập tăng và

  $ union.big_(n >= N) D_n = (a,+infinity). $

  Theo tính liên tục từ dưới của độ đo,

  $
    lambda_F((a,+infinity))
    &= lim_(n -> infinity) lambda_F(D_n) \
    &= lim_(n -> infinity)
       (F(n^+) - F(a^+)) \
    &= lim_(x -> +infinity) F(x) - F(a^+).
  $

  Vậy ta đã chứng minh được tất cả các công thức cần thiết.
]

#baitoan[
Cho $m$ là độ đo Lebesgue trên $RR$. Tìm $m([2,3])$, $m([1,5])$, $m({4})$, $m(∪_(n=1)^oo (n, n + 1/2^n))$.
]
#loigiai[
  Vì $m$ là độ đo Lebesgue trên $bb(R)$, nên với mọi $a, b in bb(R)$, $a < b$, ta có

  $ m([a,b]) = b-a, quad m({a}) = 0. $

  Suy ra,

  $ m([2,3]) = 1, quad m([1,5]) = 4, quad m({4}) = 0. $

  Đặt

  $ A = union.big_(n=1)^infinity (n, n + 1/2^n). $

  Xét họ các khoảng $A_n = (n, n + 1/2^n)$ với $n in bb(N)^*$.

  Nhận thấy các khoảng $A_n$ đôi một rời nhau. Thật vậy, với $n < m$, ta có

  $ n + 1/2^n < n+1 <= m. $

  Do đó, $A_n inter A_m = emptyset$.

  Theo tính cộng tính đếm được của độ đo Lebesgue, ta được

  $
    m(A)
    &= sum_(n=1)^infinity m(A_n) \
    &= sum_(n=1)^infinity 1/2^n \
    &= (1/2)/(1-1/2) \
    &= 1.
  $
]
#baitoan[
Tính $m_2((-1,2) times [4,7])$, $m_2(∪_(n=1)^oo A_n)$ với
$
A_n = (n,n+2^(-n)) times (n,n+3^(-n)).
$
]
#loigiai[

  Tương tự như bài toán trên, ta có $m_2((-1,2)) times[4,7]= 3 times 3 =9$. Hơn nữa, có $m_2(union.big_(n=1)^infinity A_n )=m(union.big_(n=1)^infinity (n,n+1/2^n)) times m(union.big_(n=1)^infinity (n,n+1/3^n))=1 times 1/2=1/2$.
]

#baitoan[
  Cho $F(x) = p I_([a,+infinity))(x)$, $A in cal(B)(bb(R))$. Tìm $mu_F(A)$ trong hai trường hợp $a in A$ và $a in.not A$. Suy ra $mu_F = p delta_a$.
]

#loigiai[
  Giả sử $p >= 0$. Theo định nghĩa độ đo Lebesgue–Stieltjes sinh bởi hàm $F$, với mọi $u < v$, ta có

  $
    mu_F((u,v])
    &= F(v) - F(u) \
    &= cases(
      p &quad u < a <= v,
      0 &quad "các trường hợp còn lại"
    ) \
    &= p delta_a((u,v]).
  $

  Như vậy, hai độ đo $mu_F$ và $p delta_a$ trùng nhau trên họ các khoảng $(u,v]$.

  Vì họ các khoảng này sinh ra $cal(B)(bb(R))$ và cả hai đều là độ đo hữu hạn, theo định lý duy nhất của độ đo, suy ra

  $ mu_F = p delta_a. $

  Do đó, với mọi $A in cal(B)(bb(R))$,

  $
    mu_F(A) = cases(
      p & quad a in A,
      0 & quad a in.not A.
    )
  $

]

#baitoan[
  Với $A subset X$, ta định nghĩa hàm $I_A: X -> bb(R)$ như sau:

  $
    I_A(x) = cases(
      1 & quad x in A,
      0 & quad x in X backslash A.
    )
  $

  Cho $x_1, ..., x_n in bb(R)$ và $p_1, ..., p_n > 0$. Chứng minh rằng nếu

  $
    F(x) = sum_(j=1)^n p_j I_([x_j,+infinity))(x)
  $

  thì

  $
    mu_F = sum_(j=1)^n p_j delta_(x_j).
  $
]

#loigiai[
  Với mọi $u < v$, theo định nghĩa độ đo Lebesgue–Stieltjes, ta có

  $
    mu_F((u,v])
    &= F(v) - F(u) \
    &= sum_(j=1)^n p_j
       (I_([x_j,+infinity))(v)
       - I_([x_j,+infinity))(u)) \
    &= sum_(j=1)^n p_j delta_(x_j)((u,v]).
  $

  Đặt

  $
    nu = sum_(j=1)^n p_j delta_(x_j).
  $

  Vì $p_j > 0$ với mọi $j = 1, ..., n$, nên $nu$ là một độ đo hữu hạn trên $cal(B)(bb(R))$.

  Hơn nữa, với mọi $u < v$, ta có

  $
    mu_F((u,v]) = nu((u,v]).
  $

  Do họ các khoảng $(u,v]$ sinh ra $cal(B)(bb(R))$, theo định lý duy nhất của độ đo, suy ra

  $
    mu_F = nu = sum_(j=1)^n p_j delta_(x_j).
  $

  Hay với mọi $A in cal(B)(bb(R))$,
]

#baitoan[
Cho $F(x) = 1/4 I_([0,oo)) + 1/2 I_([1,oo)) + 1/4 I_((2,oo))$. Chứng minh
$
lambda_F = 1/4 delta_0 + 1/2 delta_1 + 1/4 delta_2.
$
Tìm độ đo Stieltjes của $A=(-1/2,1/2)$, $B=(-1/2,3/2)$, $C=(2/3,5/2)$, $D=[0,2)$, $E=(3,oo)$, $G=[1,2]$, $H=[0,1)$, $K={2}$.
]

#loigiai[
 Áp dụng bài toán trên với $n=3$, ta có điều phải chứng minh. Hơn nữa $
 lambda_F (A)=1/4 delta_0 (A)+1/2 delta_1 (A)+1/4 delta_2(A)=1/4
 
 $
Tương tự, ta có $lambda_F (B)=1/4+1/2=3/4.$, $lambda_F (C)=1/2+1/4=3/4$, $lambda_F (D)=1/4+1/2=3/4, lambda_F (E)=0,lambda_F (G)=1/2 +1/4 =3/4 , lambda_F (H)=1/4 , lambda_F( K)= 1/4$.  
]
#baitoan[
Cho
$
F(x) = sum_(j=1)^oo 1/2^j I_([1/4^j,oo))(x).
$
Chứng minh
$
lambda_F = sum_(j=1)^oo 1/2^j delta_(1/4^j).
$
Tìm độ đo của các tập hợp sau: $A=[1,oo)$, $B=[1/10,oo)$, $C={0}$, $D=[0,1/2)$, $E=(-oo,0)$, $G=(0,oo)$.
]

=== Dạng 6. Các độ đo Radon-Nikodym trên ℝ

#ly-thuyet[ Nếu $f(x) ≥ 0$ và $integral_(-oo)^oo f(t) dif t < oo$ thì xác định
$
F(x) = integral_(-oo)^x f(t) dif t.
$
Khi đó $F$ tăng, $lambda_F({a}) = 0$ và với mọi $a,b ∈ RR$, $a < b$,
$
lambda_F([a,b]) &= lambda_F((a,b]) = lambda_F([a,b)) \
&= lambda_F((a,b)) = integral_a^b f(t) dif t.
$
Ta ký hiệu $ (dif lambda_F)/(dif m) = f $. Nếu $integral_(-oo)^oo f(t) dif t = 1$ thì $lambda_F$ là độ đo xác suất và $f$ gọi là hàm mật độ của độ đo này.
]
#baitoan[
Dùng máy tính, tìm độ đo $lambda_F([c,d])$ với
$
F(x) = integral_(-oo)^x f(t) dif t.
$
Đặt $f(x)=0$ trên các khoảng không ghi ra. Độ đo đó gọi là

*a)* Đều $"unif"(a,b)$: $f(x) = 1/(b-a)$ với $x∈[a,b]$, $a=0$, $b=3$, chọn $c=-1$, $d=2$.

*b)* Chuẩn $N(mu,sigma^2)$: $f(x) = 1/sqrt(2 pi sigma^2) e^(-(x-mu)^2/(2 sigma^2))$ ($x∈RR$) với $sigma=2$, $mu=0$, chọn $c=-1$, $d=1$.

*c)* Mũ $"exp"(beta)$ ($beta>0$): $f(x)=beta e^(-beta x)$ ($x>0$), $beta=1$, chọn $c=-1$, $d=4$.
]

#loigiai[

  *a)* Với độ đo $lambda_(F([c,d]))=integral_c^d f(x) dif x=integral_(0)^2 1/3 dif x=2/3$.

  *b)* Tương tự, có $lambda_(F([c,d]))=integral_(0)^1 (1)/(sqrt(8 pi))e^ ((-(x)^2)/(8)) dif x$=0.38

  *c)* Tương tự, có độ đo cần tính là
  $
  integral_0 ^4 e^(-x)dif x=0.98
  $

  
]
#baitoan[
Cho biết hàm $Gamma(z)=integral_0^oo t^(z-1)e^(-t) dif t$ xác định với $z>0$ và có các tính chất $Gamma(z+1)=z Gamma(z)$, $Gamma(n+1)=n!$, $Gamma(1/2)=sqrt(pi)$,
$
Gamma((2m+1)/2) = (1 times 3 times dots times (2m-1) sqrt(pi))/2^m, quad (m∈NN).
$
Dùng máy tính, tìm độ đo $mu_F((c,d))$ với
$
F(x) = integral_(-oo)^x f(t) dif t.
$
Đặt $f(x)=0$ trên các khoảng không ghi ra. Độ đo đó gọi là

*a)* Gamma $(alpha,beta)$ ($alpha,beta>0$): $f(x) = beta^alpha/Gamma(alpha) x^(alpha-1) e^(-beta x)$ ($x>0$), chọn $alpha=1$, $beta=1$, chọn $c=-1$, $d=3$, cho biết $Gamma(1)=1$.

*b)* Chi bình phương $chi^2(p)$ ($p>0$): $f(x)=1/(2^(p/2) Gamma(p/2)) x^(-1+p/2) e^(-x/2)$ ($x>0$), chọn $p=1$, chọn $c=1$, $d=3$.

*c)* Beta $(alpha,beta)$ ($alpha,beta>0$): $f(x) = Gamma(alpha+beta)/(Gamma(alpha)Gamma(beta)) x^(alpha-1) (1-x)^(beta-1)$ ($0<x<1$), chọn $alpha=1$, $beta=2$, chọn $c=-1$, $d=2$.

*d)* Student $t(n)$ ($n∈NN$): $f(x) = Gamma((n+1)/2)/(sqrt(n pi) Gamma(n/2)) (1+x^2/n)^(-(n+1)/2)$ ($x∈RR$), chọn $n=1$, chọn $c=-1$, $d=2$.

*e)* Fisher-Snedecor $f(p,n)$:
$
f(x) = ((p/n)^(p/2) Gamma((p+n)/2))/(Gamma(p/2) Gamma(n/2)) (x^(p/2-1))/((1+p x/n)^((p+n)/2)), quad x>0,
$
chọn $p=2$, $n=3$ và $c=1$, $d=4$.
]

=== Dạng 7. Tính chất đúng hầu hết khắp nơi

#ly-thuyet[ Cho $(X, cal(M), mu)$ và một hàm mệnh đề $P(x)$, $x ∈ X$. Ta nói $P(x)$ đúng *hầu hết khắp nơi* (almost everywhere, a.e.) theo độ đo $mu$ nếu tập
$
N = {x ∈ X: P(x) " sai"}
$
có độ đo không, nghĩa là $mu(N) = 0$. Nếu $mu$ là độ đo xác suất, ta còn gọi tính chất này là đúng *hầu chắc chắn* (almost surely, a.s.).

Để giải các bài toán, sử dụng tính chất: nếu $B ⊂ A$ và $mu(A) = 0$ thì $mu(B) = 0$; nếu $mu(A_i) = 0$ với mọi $i ∈ I$, $I ⊂ NN$, thì
$
mu(∪_(i ∈ I) A_i) = 0.
$
]
#baitoan[
Trên $RR$ với độ đo Lebesgue, chứng minh rằng mọi tập con hữu hạn, mọi tập con đếm được của $RR$ đều có độ đo Lebesgue là 0.
]
#loigiai[

  Trên $RR$ với độ đo Lebesgue, ta xét tập con $A subset.eq R$. Nếu $A=emptyset$ thì hiển nhiên $m(A)=0$, với $A != emptyset$, thì nếu $A$ hữu hạn hoặc $A$ vô hạn đếm được, thì ta đều có thể biểu diễn $A={"Hợp tùy ý của các tập có duy nhất một phần tử thuộc A"}$. Hiển nhiên, theo tính cộng tính đếm được của độ đo Lebesgue, và tính cộng tính hữu hạn ta đều suy ra được $m(A)=0$.

]
#baitoan[
Cho $h(x)=1$ hkn, $k(x)=x^2-1$ hkn theo độ đo Lebesgue trên $RR$. Chứng minh $h(x)+k(x)=x^2$ hkn.
]
#loigiai[

  Từ giả thiết, ta có $2$ tập $N_1,N_2 subset.eq R$ có độ đo Lebesgue $= 0$, sao cho $h(x)=1 , forall x in RR backslash N_1$ và $k(x)=x^2-1,forall x in RR backslash N_2$. Khi đó, ta cần tìm tập $N subset.eq RR$ sao cho $N$ có độ đo Lebesgue $=0$. Khi đó, chọn $N=N_1 union N_2=> m(N) <=m(N_1)+m(N_2)<=0$. Do đó, $m(N)=0$, hơn nữa, $forall x in RR backslash N, h(x)+k(x)=x^2-1+1=x^2 quad (h k n)$. Vậy, ta có điều phải chứng minh.
]

#baitoan[
Cho hàm $f(x)=1/(sin x)$ với $x≠k pi$, $f(k pi)=1$ với $k∈ZZ$, $g(x)=1/(sin x)$ với $x≠k pi$, $g(k pi)=0$ với $k∈ZZ$. Chứng minh $f=g$ hầu hết khắp nơi theo độ đo Lebesgue.
]
#loigiai[
Dễ thấy, ngoài điểm $x=k pi$ thì ta đều có $f=g$. Tại $x=k pi $ thì $f=g quad ("Sai")$. Nên ta chứng minh $N={k in ZZ : x=k pi}$ có độ đo không, hiển nhiên $m(N)=0$, Do $N$ là tập đếm được. Do đó, $f=g$ hầu hết khắp nơi, do $f=g,forall x in RR backslash N$.
  
]
#baitoan[
Cho hàm $f(x)=1/abs(cos x)$ với $cos x≠0$, $f(x)=1$ với $cos x=0$; $g(x)=2/abs(cos x)$ với $cos x≠0$, $g(x)=-3$ với $cos x=0$. Chứng minh $0≤f≤g$ hầu hết khắp nơi theo độ đo Lebesgue.
]
#loigiai[

  Dễ thấy, $forall x in RR, abs(cos(x))<=1$, nên ta luôn có $0<=f<=g,forall x in RR quad (1)$. Mặt khác, tập các điểm làm $(1) "sai"$ là tập $N={pi/2 + k pi : k in ZZ}$,có $N$ là tập đếm được dễ thấy $m(N)=0$ nên $0<=f<=g,forall x in RR backslash N$ hkn.

  
]
#baitoan[
Nếu $f_1=g_1$, $f_2=g_2$ hkn thì $f_1±f_2=g_1±g_2$, $f_1 f_2=g_1 g_2$ hkn.
]
#loigiai[
  Giả sử $f_1 =g_1,f_2=g_2 quad "(hkn)"$. Thì có tập $N_1 subset.eq RR$ sao cho $m(N_1)=0$ để $f_1=g_1,forall x in RR backslash N_1$ và có tập $N_2 subset.eq RR$ sao cho $m(N_2)=0$ để $f_2=g_2,forall x in RR backslash N_2$. Để chứng minh cả $3$ tính chất trên, ta đều chọn $N=N_1 union N_2$ và luôn có $m(N)=0$.
]
#baitoan[
Chứng minh rằng nếu $f=g$ hkn và $g=h$ hkn thì $f=h$ hkn.
]
#loigiai[

  Tương tự các ý toán trên, ta chọn $N=N_1 union N_2$.
]
#baitoan[
Nếu $f_n=g_n$ hkn với mọi $n=1,2,dots$ và nếu $lim_(n→oo) f_n=f$ hkn, $lim_(n→oo) g_n=g$ thì $f=g$ hkn.
]

#loigiai[

  Vì $f_n=g_n "hkn"$ với mọi $n in NN^*$, thì ta luôn có $N_1$ thỏa $m(N_1)=0$ và $f_n = g_n forall n in NN^* backslash N_1$. Hơn nữa có $lim_(n->infinity) f_n=f => "Có"$ $N_2$ thỏa $m(N_2)=0$ và $lim_(n-> infinity) f_n=f quad forall n in NN^* backslash N_2$, tương tự ta có $N_3$, thỏa $m(N_3)=0$ và $lim_(n->infinity) g_n=g  quad forall n in NN^* backslash N_3$. Ta cần chứng minh $f=g "hkn"$.Nếu ta chọn $N= N_1 union N_2 union N_3$, thì ta luôn có
  $
  lim_(n->infinity) (f_n-g_n)=f-g=0 => f=g "hkn"
  $
  Hơn nữa, có $m(N)<= m(N_1)+m(N_2)+m(N_3)=0$, do đó $m(N)=0$ và thỏa $f=g ,forall n in NN^* backslash N$.
]
#baitoan[
Nếu tồn tại $M>0$ sao cho $abs(f(x))≤M$ hkn thì ta nói $f$ bị chặn hkn. Chứng minh rằng nếu $f,g$ bị chặn hkn thì $f±g$, $f g$ bị chặn hkn.
]
#loigiai[

  Giả sử $f,g$ bị chặn hkn. Khi đó, có $M_1>0$ sao cho $abs(f(x))<=M "hkn"$ suy ra , có $N_1$ thỏa $m(N_1)=0$ và $abs(f(x))<=M_1,forall x in RR backslash N_1$, tương tự luôn có $M_2>0$ sao cho $abs(g(x))<=M_2 "hkn"$, $N_2$ tương ứng. Ta chứng minh $f+g$ bị chặn hkn. Thật vậy, chọn $N=N_1 union N_2$ $
  abs(f(x)+g(x))<=abs(f(x))+abs(g(x))<=M_1+M_2 forall x in RR backslash N =>  f+g "bị chặn hkn"
  $
  Tương tự với $f-g$ và với $ abs(f (x)(g(x)))<=M_1 M_2 "hkn" => f g "bị chặn hkn" $.

]
#baitoan[
Nếu $f$ bị chặn hkn. Đặt
$
||f||_oo = inf{M: abs(f(x)) ≤ M " hkn"}.
$
Chứng minh rằng $abs(f(x))≤||f||_oo$ hkn.
]

#baitoan[
Nếu $f,g$ bị chặn hkn thì
$
||f+g||_oo ≤ ||f||_oo+||g||_oo.
$
]
= Biến Ngẫu Nhiên

Cho không gian xác suất $(Omega,cal(M),P)$. Ta thấy nhiều trường hợp trong thực tế, kết quả của phép thử (ngẫu nhiên) là các giá trị số. Thí dụ : Nhiệu độ trong ngày, Lượng mưa, số khách hàng, doanh thu, giá xăng.

Ta cần một công cụ để liên kết các giá trị số $in RR$ với các kết quả của phép thử. Do đó, với ánh xạ $X : Omega -> RR, quad omega -> X(omega)$, ta có thể liên kết được.

#dinhnghia[
Ánh xạ $ X: Omega -> RR $ được gọi là một biến ngẫu nhiên (b.n.n) nếu :

$
(X in (-infinity,a])=(X<=a):=X^(-1)(-infinity,a]={omega in Omega : X(omega) <=a} in cal(M), forall a in RR.
$
b.n.n X bản chất là ánh xạ đo được 

$
X:(Omega,cal(M)) -> (RR, cal(B(RR)))
$

$X$ gọi là ánh xạ đo được nếu $X^(-1)(cal(B)) in cal(M),forall cal(B)in cal(B(RR))$.
]
Khi đó, với độ đo xác suất $P$, ta có :
$
P(X<=a):=P({omega in Omega : X(omega) <= a,forall a in RR}).
$
#vidu[
Phép thử tung $1$ đồng xu $2$ lần liên tiếp
$
Omega={S S,S N,N S,N N}
$
Gọi $X$ là số lần đồng xu xuất hiện "N", ta có : 

$
X({S S})&=0\
X({S N})&=1,X({N S })=1\
X({N N})&=2\
$
và miền giá trị của $X(Omega)={0,1,2}$.
Hơn nữa , $
(X<=1)={omega in Omega : X(omega)<=1}={a in Omega : X(a)=0} union {b in Omega : X(b)=1}={S S} union {S N , N S}={S S, S N , N S}.
$
Và $P(X<=1)=P({S S,S N, N S})=3/4$
]

== Hàm phân phối xác suất (Probability Distrubition Function)
#dinhnghia[
  
  Cho $X$ là biến ngẫu nhiên trên không gian xác suất $(Omega,cal(M),P)$, khi đó , hàm phân phối xác suất (còn gọi là hàm phân phối xác suất tích lũy - cumulative probability distribution function ) của bnn X được định nghĩa là :
$
F_(x)(u):=P(X<=u), "với u" in RR
$
Ta thấy : 
$
F_x : RR -> [0,1]
$
Các tính chất :

*(i)* $0<=F_(x) (u)<=1, forall u in RR$.

*(ii)* $F_(x)$ là hàm không giảm (non-decreasing), tức là với $u<x$ thì $
F_(x)(u)<=F_(x)(v)
$

*(iii)* $F_x$ là hàm liên tục phải, tức là :
$
lim_(t->u^+) F_(x)(t)=F_(x)(u), forall u in RR
$

*(iv)* $
lim_(u-> -infinity)=lim_(u-> -infinity) P(X<=u)=0
$
và 
$
lim_(u-> infinity) F_(x)(u)=lim_(u-> infinity) P(X<=u)=1
$

]
Đặt $D_x={"tất cả các điểm không liên tục của "F_x}$.

Nhắc lại : $x$ là 1 điểm giới hạn (limit point) của tập $D$ 
$
<=> (U backslash {x}) inter D= emptyset quad forall "tập mở " U "chứa "x
$
#dinhly[
  Nếu $D_x$ không có điểm giới hạn khi đó, hàm phân phối tích lũy $F_X$ có thể phân tích thành :
  $
  F_(X)(u)=F(u)+G(u) , forall u in RR
  $
  Trong đó : $G$ là hàm liên tục và không giảm, $F$ là hàm bậc thang không giảm. và thể xét dưới dạng :
  $
  F(u)=sum_(a in D_X) P(X=a) I_[a,infinity)(x)
  $
]
#dinhnghia[
  *Phân loại biến ngẫu nhiên *

 - Nếu $F_(X)=F, F_(x)(u)=F(u),forall u in RR quad ("Hàm bậc thang tăng")$, ta nói $X$ là biến ngẫu nhiên rời rạc.

 - Nếu $F_(X)(u)= G(u), quad forall u in RR$ thì $X$ gọi là biến ngẫu nhiên liên tục.

 - Nếu $F!=0,G!=0$, ta nói $X$ là biến ngẫu nhiên hỗn hợp.
]
#vidu[
  $X$ là số lần xuất hiện N khi tung $1$ xu $2$ lần liên tiếp.

  Ta có : Miền giá trị $X(Omega)={0,1,2}$. Ta đi xác định hàm phân phối xác suất tích lũy của $X$.

  Theo định nghĩa :
  $
  F_(x)(u):=P(X<=u), quad "với" u in RR
  $

  +) Xét $u<0$ ta có : 
  $
  F_(x)(u)=P(X<=u)=P(emptyset)=0
  $

  +) Xét $0<=u<=1$, ta có :
  $
  F_(X)(u)=P(x<=u)=P(X=0)=1/4=P({S S})
  $
  +) Xét $1<u<2$, ta có :
  $
  F_(x)(u)=P(X<=u)=P(X=0)+P(X=1)=P("S S")+P("{S N,N S}")=1/4+2/4=3/4

  $
  +) Xét $2<=u$, ta có
  $
  F_(x)(u)=P(x<=u) = P(X=0)+P(X=1)+P(X=2)=1/4+1/4+2/4=1
  $
  Vậy,
  $
  F_(x)=cases(0 quad ",nếu " u<0,

  1/4 quad ",nếu " 0<=u<=1,

  3/4 quad ",nếu " 1<=u< 2,

  1 quad  ",nếu" 2<=y
)
  $
Ta thấy $D_x={0,1,2}$, $F_(x)(0^-)=lim_(u arrow.t 0) F_(x)(u)=lim_(u arrow.t 0)=0$.

$F_(x)(0^+)=lim_(u arrow.b 0) F_(x)(u)=F_(x)(0)=1/4$ nên $F$ không liên tục tại $0$.

Do đó, $
F_(u)=sum_(a in D_x) P(X=a) I_[a,infinity) (u) &=P(X=0) I_[0,infinity)+ P(X=1)I_[1,infinity) + P(X=2) I_[2,infinity)\
&= 1/4 I_[0,infinity)(u) + 2/4 I_[1,infinity) (u) +1/4 I_[2,infinity)
$
Suy ra,
$
F_(X)=(u)=F(u),forall u in RR
$
nên $X$ là bnn rời rạc. $G(u)=0,forall u in RR$.




]

#vidu[
  Cho bnn $Y$ là tuổi thọ của $1$ linh kiện điện tử (đvị:giờ). Giả sử $Y$ có hàm phân phối xác suất tích lũy :
  $
  F_(Y)(u)=cases(1-e^(-u/200)  "với "u>=200,
  0 quad " với u"<200

)
  $
  Ta có $D_Y= emptyset$, do đó có $F_(y)(0^-)=0$ và $F_(y)(0^+)=lim_(u arrow.b 0) F_(y)(u)=F_(y)(0)=1-e^(-0/200)=0$ vì $D_y=emptyset$ nên $F_(y)(u)=G(u),forall u in RR$ suy ra $Y$ là biến ngẫu nhiên liên tục.
]

Do hàm phân phối tích lũy $F_X$ của một biến số ngẫu nhiên $X: Omega -> RR$ là một hàm tăng, tồn tại độ đo Stieltjes $lambda_(F_X) equiv lambda_X$ xác định trên $sigma$-đại số Borel $cal(B)(RR)$ của $RR$ (xem Ví dụ 1.7d Chương 1) sao cho với mọi $x in RR$,

$
  lambda_X((-infinity, x])
  = F_X(x) - lim_(a -> -infinity) F_X(a)
  = F_X(x).
$

Do $lambda_X(RR) = 1$ nên $lambda_X$ là một độ đo xác suất trên $RR$, mà ta còn gọi là _phân bố_ hay _phân phối_ (distribution) của biến ngẫu nhiên $X$. Bây giờ, với mọi tập Borel-đo được $A$ trong $RR$, ta có

$
  P(X in A) = lambda_X(A). " " (5)
$

Đẳng thức (5) cho thấy rằng một khi phân bố $lambda_X$ của biến số ngẫu nhiên $X$ được xác định, các tính toán xác suất liên quan đến $X$ được thực hiện trên không gian xác suất $(RR, cal(B)(RR), lambda_X)$, không cần đến không gian xác suất nền $(Omega, cal(P)(Omega), P)$.

Từ khái niệm phân phối của biến ngẫu nhiên, ta có định nghĩa: Cho $(Omega, cal(M), P)$ và hai biến ngẫu nhiên $X,Y: Omega -> RR$. Ta nói $X$ và $Y$ _cùng phân phối_ nếu $P(X in A) = P(Y in A)$, $forall A in cal(B)(RR)$.

Để xây dựng phân bố $lambda_X$ cho biến số ngẫu nhiên $X$, ta xét hàm phân phối tích lũy $F_X = F + G$ với tập các điểm không liên tục $D_X$. Xét hàm số $f_X: RR -> RR$ xác định bởi $f_X = G'$ và xét độ đo $lambda_X^d$ xác định bởi

$
  lambda_X^d = sum_(x in D_X) p_x delta_x,
$

trong đó $p_x = P(X = x) = F(x) - lim_(t -> x^(-)) F(t)$ và $delta_x$ là độ đo Dirac tại điểm $x in D_X$ (xem Ví dụ 1.7b Chương 1). Ta có kết quả sau, một trường hợp đặc biệt của định lý Lebesgue-Radon-Nikodym trong lý thuyết độ đo tổng quát (xem [5, 7]).

#dinhly[
Ta có

$
  lambda_X(A) = lambda_X^d(A) + integral_A f_X(x) d x.
$
với mọi tập Borel đo được $A in cal(B)(RR)$. Ta ký hiệu

$
  lambda_X = lambda_X^d + f_X d x.
$
]
*Ví dụ 2.3.*

a) Biến số ngẫu nhiên $X$ cho trong Ví dụ 2.1 có hàm phân phối tích lũy

$
  F_X(x) = P(X <= x) = cases(
    0 & "khi " x < 0,
    1/4 & "khi " 0 <= x < 1,
    3/4 & "khi " 1 <= x < 2,
    1 & "khi " x >= 2
  )
$

cho $D_X = {0,1,2}$, $f_X(x) = 0$, với mọi $x in RR backslash {0,1,2}$, và

$
  lambda_X = 1/4 delta_0 + 1/2 delta_1 + 1/4 delta_2.
$

Đối chiếu với Ví dụ 2.2a, ta có

$
  P(1 < X <= 2) = lambda_X((1,2])
$

$
  = 1/4 delta_0((1,2]) + 1/2 delta_1((1,2])
  + 1/4 delta_2((1,2])
  = 0 + 0 + 1/4 = 1/4.
$

$
  P(X = 1) = lambda_X({1})
$

$
  = 1/4 delta_0({1}) + 1/2 delta_1({1})
  + 1/4 delta_2({1})
  = 0 + 1/2 + 0 = 1/2.
$

$
  P(X = 2) = lambda_X({2})
$

$
  = 1/4 delta_0({2}) + 1/2 delta_1({2})
  + 1/4 delta_2({2})
  = 0 + 0 + 1/4 = 1/4.
$

và

$
  P(1 <= X <= 2) = lambda_X([1,2])
$

$
  = 1/4 delta_0([1,2]) + 1/2 delta_1([1,2])
  + 1/4 delta_2([1,2])
  = 0 + 1/2 + 1/4 = 3/4.
$

$
  P(1 < X < 2) = lambda_X((1,2))
$

$
  = 1/4 delta_0((1,2)) + 1/2 delta_1((1,2))
  + 1/4 delta_2((1,2))
  = 0 + 0 + 0 = 0.
$

$
  P(1 <= X < 2) = lambda_X([1,2))
$

$
  = 1/4 delta_0([1,2)) + 1/2 delta_1([1,2))
  + 1/4 delta_2([1,2))
  = 0 + 1/2 + 0 = 1/2.
$

b) Xét biến số ngẫu nhiên $X$ trong Ví dụ 2.2b, với hàm phân phối tích lũy

$
  F_X(x) = P(X <= x) = cases(
    0 & "khi " x < 0,
    x & "khi " 0 <= x < 1,
    1 & "khi " x >= 1
  )
$

Ta có $D_X = emptyset$ và

$
  f_X(x) = cases(
    1 & "khi " x in (0,1),
    0 & "khi " x in.not (0,1)
  )
$

Do đó $lambda_X = f_X d x$.

Và đối chiếu với Ví dụ 2.2b,

$
  P(0.2 < X < 0.7)
  = lambda_X((0.2,0.7))
$

$
  = integral_((0.2,0.7)) f_X(x) d x
  = integral_(0.2)^(0.7) d x
  = [x]_(0.2)^(0.7)
  = 0.7 - 0.2 = 0.5.
$

c) Xét biến số ngẫu nhiên $X$ trong Ví dụ 2.2c, với hàm phân phối tích lũy

$
  F_X(x) = P(X <= x) = cases(
    0 & "khi " x < 0,
    0.8x & "khi " 0 <= x < 0.5,
    0.8x + 0.2 & "khi " 0.5 <= x < 1,
    1 & "khi " x >= 1
  )
$

Ta có $D_X = {0.5}$; $P(X = x) = 0$, với mọi $x in RR backslash {0.5}$,

$
  p_(0.5) = P(X = 0.5) = 0.2
$

và

$
  f_X(x) = cases(
    0.8 & "khi " x in (0,0.5) union (0.5,1),
    0 & "khi " x in.not (0,0.5) union (0.5,1)
  )
$

Do đó

$
  lambda_X = 0.2 delta_(0.5) + f_X d x
$

và đối chiếu với Ví dụ 2.2c,

$
  P(X = 0.5) = lambda_X({0.5})
$

$
  = 0.2 delta_(0.5)({0.5})
  + integral_({0.5}) f_X(x) d x
  = 0.2 + 0 = 0.2.
$

$
  P(0.2 <= X <= 0.5) = lambda_X([0.2,0.5])
$

$
  = 0.2 delta_(0.5)([0.2,0.5])
  + integral_([0.2,0.5]) f_X(x) d x
$

$
  = 0.2 + integral_(0.2)^(0.5) 0.8 d x
  = 0.2 + 0.8 [x]_(0.2)^(0.5)
  = 0.44.
$

và

$
  P(0.2 <= X < 0.5) = lambda_X([0.2,0.5))
$

$
  = 0.2 delta_(0.5)([0.2,0.5))
  + integral_([0.2,0.5)) f_X(x) d x
$

$
  = 0 + integral_(0.2)^(0.5) 0.8 d x
  = 0.24.
$

*Ghi chú.* Trong đẳng thức ở Định lý 2.8,

$
  lambda_X = lambda_X^d + f_X d x,
$

độ đo $lambda_X^d$ được gọi là phần "rời rạc" của $lambda_X$ và độ đo $f_X d x$ xác định bởi

$
  f_X d x(A) = integral_A f_X(x) d x,
  quad A in cal(B)(RR),
$

được gọi là phần "liên tục" của $lambda_X$.

Do $D_X$ là một tập Borel-đo được,

$
  m(D_X) = lambda_X^d(RR backslash D_X) = 0. " " (6)
$

và với mọi $A in cal(B)(RR)$,

$
  m(A) = 0
  arrow.r.double f_X d x(A) = 0. " " (7)
$

nên với từ ngữ của lý thuyết độ đo, (6) cho thấy $lambda_X^d$ là _kỳ dị_ (singular) đối với độ đo Lebesgue $m$, ký hiệu

$
  lambda_X^d perp m,
$

và (7) cho thấy $f_X d x$ _liên tục tuyệt đối_ (absolutely continuous) đối với độ đo Lebesgue $m$, ký hiệu

$
  f_X d x l l m.
$

Hơn nữa, hàm $f_X$ được gọi là _đạo hàm Radon-Nikodym_ của độ đo $lambda_X$ đối với độ đo Lebesgue $m$, ký hiệu

$
  (d lambda_X)/(d m) = f_X.
$

#dinhly[

Cho $X$ là một biến số ngẫu nhiên với phân bố $lambda_X = lambda_X^d + f_X d x$ cho trong Định lý 2.1.6.

(i) Nếu $f_X = 0$, thì $X$ là biến rời rạc (discrete), $lambda_X = lambda_X^d$.

(ii) Nếu $D_X = emptyset$, nghĩa là $lambda_X = f_X d x$, thì $X$ là biến liên tục (continuous) với hàm mật độ xác suất (probability density function) $f_X$.

(iii) Nếu $D_X != emptyset$ và $f_X != 0$, thì $X$ là biến hỗn hợp (mixed type).
]
*Ví dụ 2.4.*

a) Biến số ngẫu nhiên $X$ trong Ví dụ 2.3a là biến rời rạc với

$
  lambda_X = lambda_X^d
  = 1/4 delta_0 + 1/2 delta_1 + 1/4 delta_2.
$

b) Biến số ngẫu nhiên $X$ trong Ví dụ 2.3b là biến liên tục,

$
  lambda_X = f_X d x,
$

với hàm mật độ xác suất

$
  f_X(x) = cases(
    1 & "khi " x in (0,1),
    0 & "khi " x in.not (0,1)
  )
$

c) Biến số ngẫu nhiên $X$ trong Ví dụ 2.3c là biến hỗn hợp,

$
  lambda_X = lambda_X^d + f_X d x,
$

với $lambda_X^d = 0.2 delta_(0.5)$ và

$
  f_X(x) = cases(
    0 & "khi " x < 0,
    0.8 & "khi " 0 <= x < 1,
    0 & "khi " x >= 1
  )
$

Hơn nữa, xét biến số ngẫu nhiên $X$ với phân bố $lambda_X = lambda_X^d + f_X d x$. Với mọi hàm liên tục $u: RR -> RR$, xét biến số ngẫu nhiên $u(X) = u compose X: Omega -> RR$, ta có

$
  integral_Omega u(X) d P
  = integral_RR u(x) d lambda_X(x)
$

$
  = integral_RR u(x) d lambda_X^ d(x)
  + integral_RR u(x) f_X(x) d x. " " (8)
$
== Kỳ Vọng

#dinhnghia[

Cho $X$ là biến số ngẫu nhiên xác định trên không gian xác suất $(Omega, cal(P)(Omega), P)$ với phân bố $lambda_X = lambda_X^d + f_X d x$. Giá trị của (8) được gọi là _kỳ vọng_ (expectation) của biến số $u(X) = u compose X$, ký hiệu $E[u(X)]$. Đặc biệt,

+ Với $u(x) = x$, $E[X]$ được gọi là _trung bình_ (mean) của $X$,

  $
    E[X] = integral_Omega X d P
    = integral_RR x d lambda_X^d(x)
    + integral_RR x f_X(x) d x ;
  $

+ Với $u(x) = (x - E[X])^2$,

  khi $E[X] in RR$, $E[(X - E[X])^2]$ được gọi là _phương sai_ (v a riance) của $X$, ký hiệu $v a r[X]$,

  $
    v a r[X] = E[(X - E[X])^2]
    = integral_Omega (X - E[X])^2 d P
  $

  $
    = integral_RR (x - E[X])^2 d lambda_X^d(x)
    + integral_RR (x - E[X])^2 f_X(x) d x ;
  $

  $sigma_X = sqrt(v a r[X])$ được gọi là _độ lệch chuẩn_ (standard deviation) của $X$;

+ Với $u(x) = x^k$, $k in NN$, $E[X^k]$ được gọi là _momen_ (moment) cấp $k$ của $X$, ký hiệu $m_k(X)$,

  $
    m_k(X) = E[X^k]
    = integral_Omega X^k d P
    = integral_RR x^k d lambda_X^d(x)
    + integral_RR x^k f_X(x) d x ;
  $

  Khi $E[X] in RR$ và $u(x) = (x - E[X])^k$, $k in NN$, $E[(X - E[X])^k]$ được gọi là _momen trung tâm_ (central moment) cấp $k$ của $X$, ký hiệu $sigma_k(X)$,

  $
    sigma_k(X) = E[(X - E[X])^k]
    = integral_Omega (X - E[X])^k d P
  $

  $
    = integral_RR (x - E[X])^k d lambda_X^d(x)
    + integral_RR (x - E[X])^k f_X(x) d x ;
  $

+ Với $u(x) = e^(t x)$, $t in RR$, hàm số

  $
    M_X(t) = E[e^(t X)]
    = integral_Omega e^(t X) d P
    = integral_RR e^(t x) d lambda_X^d(x)
    + integral_RR e^(t x) f_X(x) d x
  $

  được gọi là _hàm sinh momen_ (moment generating function) của $X$, ký hiệu $M_X$.
]

#dinhly[

Cho $X,Y: Omega -> RR$ là hai biến ngẫu nhiên thỏa $E[X], E[Y] < infinity$. Khi đó

$
  E[X+Y] = E[X] + E[Y],
$

$
  E[alpha X] = alpha E[X], quad forall alpha in RR,
$

$
  E[c] = c, quad forall c in RR,
$

nếu $X <= Y$ thì $E[X] <= E[Y]$.
]
*Ví dụ 2.5.*

a) Đặt $a = sum_(k=1)^infinity 1/k^2 < infinity$. Xét biến số ngẫu nhiên rời rạc $X$ có tập các điểm không liên tục $D_X = NN$ với phân bố

$
  lambda_X = lambda_X^d
  = sum_(x in D_X) a/x^2 delta_x. " " (9)
$

Ta có

$
  E[X]
  = integral_RR x d lambda_X^d(x)
  = sum_(x in D_X) a/x^2 integral_RR x d delta_x
  = sum_(x=1)^infinity a/x
  = infinity.
$

Chú ý rằng do

$
  sum_(x in D_X) a/x^2
  = a sum_(x=1)^infinity 1/x^2
  = 1
$

nên vế phải của (9) xác định một độ đo xác suất trên $RR$.

b) Xét biến số ngẫu nhiên liên tục $X$ với phân bố $mu_X = f_X d x$, trong đó

$
  f_X(x) = 1/pi 1/(x^2+1).
$

Ta có

$
  E[X]
  = integral_RR x f_X(x) d x
  = 1/pi integral_(-infinity)^infinity x/(x^2+1) d x
$

$
  = 1/pi (1/2 ln(x^2+1) bar_(-infinity)^infinity)
  = infinity.
$

Chú ý rằng do $f_X(x) >= 0$, với mọi $x in RR$, và

$
  integral_(-infinity)^infinity 1/(x^2+1) d x
  = 2 integral_0^infinity 1/(x^2+1) d x
  = 2 (arctan x bar_0^infinity)
  = pi
$

nên $f_X d x$ xác định một độ đo xác suất trên $RR$.
== Vector Ngẫu Nhiên

Trong thực tế, xuất hiện bài toán mà ta cần đánh giá, ngẫu nhiên $2$ hay nhiều b.n.n cùng lúc. Chẳng hạn : (air quality monitoring)=y.



$X_1 :$ Nhiệt độ không khí, $X_2 :$ Độ ẩm, $X_3 :$ Mức độ bụi mịn, $X_4 :$ Hướng gió

Khi đó, ta muốn đánh giá cùng một lúc, thì đánh giá thông qua Vector $(X_1,X_2,X_3,X_4)$, với mỗi thành phần là b.n.n.

#dinhnghia[

  Cho không gian xác suất $(Omega,cal(m),cal(P))$, khi đó vector 
$
V: quad Omega & -> RR^2 \
        omega & |-> V(omega) = (X_1(omega), X_2(omega))
$Trong môn học này, ta chỉ quan tâm trên $RR^2$. Gọi là vector ngẫu nhiên trên $(Omega,cal(M),cal(P))$ nếu
  $
  V^(-1) (A):={omega in Omega : V(omega)=(X_1(omega),X_2(omega)}in cal(M),forall A in cal(B(RR^2)).
  $
  hay
  $
  V^(-1) ((-infinity,a]times(-infinity,b])={omega in Omega : X_1(omega) <= a,X_2(omega)<=b} in cal(M), forall a,b in RR
  $
  Khi đó, hàm phân phối tích lũy của vector ngẫu nhiên $V=(X_1,X_2)$ được định nghĩa bởi :
  $
  F_v((a,b))=cal(P) (X_1<=a,X_2<=b), forall a,b in RR
  $
  Hàm $F_v$ vẫn thỏa các tính chất cơ bản của hàm phân phối xác xác tích lũy của b.n.n. Hơn nữa, ta có
  $
  F_(x_1) (a)=lim_(b->infinity) F_V (a,b)=P(X_1<=a) quad "và" F_(X_2)(b)=lim_(a->infinity) F_v(a,b)=P(X_2<=b).
  $
  gọi là hàm phân phối xác suất lề tương ứng của $X_1$ và $X_2$.

  
  
  
]
=== Hiệp Phương Sai
Trong thống kê, ta có thể sử dụng đại lượng covariance để đánh giá mối liên hệ tuyến tính giữa $2$ b.n.n. Ta nói $Y$ có mối liên hệ tuyến tính với $X$. Nếu ta có thể viết : $Y=beta_0 +beta_1 X$.

#dinhnghia[

  $C o v(X,Y)=E[(X-E(X))(Y-E[Y])]=E(X Y)-E(X) E(Y)$
]
Ta cũng định nghĩa hệ số tương quan (correlation) giữa $2$ b.n.n $X$ và $Y$ là :
$
p(X,Y)=(C o v(X,Y))/ sqrt(V a r (X) . V a r(Y))
$
ta chứng minh được $-1<=p(X,Y)<=1$.Hơn nữa,
$
C o v(X,X)=E(X^2)-(E(X))^2=V a r(X)
$

=== Hai Biến Ngẫu Nhiên Độc Lập
#dinhnghia[

  Cho $2$ b.n.n $X,Y$ xác định trên cùng không gian xác suất $(Omega,cal(M),cal(P))$ thì $2$ b.n.n được gọi là độc lập nếu :
  $
  P(X in A, Y in B)=P((X in A) inter (Y in B))=P(X in A) times P(Y in B), forall A,B in cal(B(RR)).
  $
  Hay 

  $
  P(X<=A,Y<=b)=P(X<=a) times P(Y<=b), forall a,b in RR
  $

]
#menhde[

  Nếu $2$ b.n.n $X,Y$ độc lập thì với vector ngẫu nhiên $V=(X,Y)$, ta có
  $
  F_v(a,b)=P(X<=a,Y<=b)=P(X<=a) times P(Y<=b)=F_x (a) times F_x (b),forall a,b in RR
  $
  
]
#menhde[

  Cho $h,g : &R -> RR$ là các hàm liên tục thỏa
  $
  E(abs(h(x)))<infinity "và" E(abs(g(x)))<infinity
  $
  Nếu $2$ b.n.n X,Y độc lập thì :
  $
  E(h(x)g(y))=E(g(x))times E(h(y))
  $
  
 

]
Một số tính chất :

Cho $2$ b.n.n $X,Y$ độc lập, ta có :
- $E(X.Y)=E(X).E(Y)$
- $C o v (X,Y)=0$
- $V a r (a X+ b Y)=V a r(a X)+ V a r(b Y)$.




#pagebreak()
== Bài Tập
=== Biến Ngẫu Nhiên
==== Dạng 1. Tìm ảnh ngược của một hàm số
#ly-thuyet[
Ta sử dụng các tính chất

$
  (f in A) = f^(-1)(A)
  = {x in X : f(x) in A},
$

$
  (f > a) = f^(-1)((a, infinity))
  = {x in X : f(x) > a},
$

$
  (a < f < b) = f^(-1)((a,b))
  = {x in X : a < f(x) < b}.
$

Cho

$
  s(X) = {alpha_1, dots, alpha_n},
$

$
  (s = alpha_i) = A_i
  = {x in X : s(x) = alpha_i}.
$

Với mọi tập $B subset.eq RR$, đặt
$J = {i in I : alpha_i in B}$, ta có

$
  (s in B) = s^(-1)(B)
  = union.big_(i in J) A_i.
$
]
#baitoan[
  Cho $f: RR -> RR$. Tìm

  $
    f^(-1)((a,b)) = (a < f < b),
  $

  $
    f^(-1)([a,infinity)) = (f >= a),
  $

  $
    f^(-1)((-infinity,b]) = (f <= b),
  $

  với $f(x)$ và $a,b$ lần lượt là

  (a) $f(x) = 3x - 1$, $a = -4$, $b = 2$.

  (b) $f(x) = x^2$, $a = -4$, $b = 9$.

  (c) $f(x) = e^x$, $a = -4$, $b = -3$.
]
#loigiai[
  *a)*
  
  Với $f(x)=3x$ và $a=-4,b=2$ thì  $f^(-1)((-4,2))=-4<f(x)<2<=>-4<3x-1<2<=>-1<x<1$. Và $f^(-1)(-a,infinity)=(f>=a)<=> 3x-1>=-4<=> x>=-1$. Lại có $f^(-1)(infinity,b)=(f<=b)<=>3x-1<=2<=>x<=1$.

  *b)* Tương tự, ta có $f^(-1)(-4,9)<=>-4<x^2<9<=>-3<x<3$. Và $f^(-1)(a,infinity)<=> x^2>=-4<=> x in RR$. Có $f^(-1)(-infinity,b)=x^2<=9<=> -3<=x<=9$

  *c)* Có $f^(-1)(-4,-3)<=>-4<e^x< -3<=> x in emptyset$. $f^(-1)[-4,infinity)=e^x>=-4 <=> x in RR$. Và $f^(-1)(-infinity,-3]= e^x<=-3 <=> x in emptyset$;
]

#baitoan[
  Cho thí nghiệm tung hai đồng xu.

  (a) Gọi $X$ là số mặt ngửa xuất hiện. Tìm $P(X <= a)$ với mọi $a in RR$.

  (b) Giả sử có trò chơi thắng 5.000 nếu hai mặt ngửa, thắng 10.000 nếu hai mặt sấp, và thua 10.000 nếu một mặt ngửa, một mặt sấp. Gọi $Y$ là số tiền thu được. Tìm $P(Y <= a)$ với $a in RR$.
]

#loigiai[
  Gọi $N$ là mặt ngửa và $S$ là mặt sấp. Không gian mẫu của phép thử là

  $
    Omega = {(N,N), (N,S), (S,N), (S,S)}.
  $

  Giả sử hai đồng xu cân đối và độc lập, khi đó các kết quả đồng khả năng, mỗi kết quả có xác suất bằng $1/4$.

  *a)* Vì $X$ là số mặt ngửa xuất hiện nên $X$ nhận các giá trị $0,1,2$. Ta có

  $
    P(X = 0) = P({(S,S)}) = 1/4,
  $

  $
    P(X = 1) = P({(N,S),(S,N)}) = 1/2,
  $

  $
    P(X = 2) = P({(N,N)}) = 1/4.
  $

  Theo định nghĩa, hàm phân phối tích lũy của $X$ là $F_X(a) = P(X <= a)$.

  + Nếu $a < 0$ thì $P(X <= a) = 0$.

  + Nếu $0 <= a < 1$ thì $P(X <= a) = P(X = 0) = 1/4$.

  + Nếu $1 <= a < 2$ thì $P(X <= a) = P(X = 0) + P(X = 1) = 3/4$.

  + Nếu $a >= 2$ thì $P(X <= a) = 1$.

  Vậy

  $
    F_X(a) = cases(
      0 & "nếu " a < 0,
      1/4 & "nếu " 0 <= a < 1,
      3/4 & "nếu " 1 <= a < 2,
      1 & "nếu " a >= 2
    ).
  $

  *b)* Gọi $Y$ là số tiền thu được. Khi đó

  $
    Y(omega) = cases(
      5000 & "nếu " omega = (N,N),
      10000 & "nếu " omega = (S,S),
      -10000 & "nếu " omega in {(N,S),(S,N)}
    ).
  $

  Vì $Y$ nhận các giá trị $-10000,5000,10000$, ta có

  $
    P(Y = -10000) = 1/2,
  $

  $
    P(Y = 5000) = 1/4,
  $

  $
    P(Y = 10000) = 1/4.
  $

  Theo định nghĩa, $F_Y(a) = P(Y <= a)$.

  + Nếu $a < -10000$ thì $P(Y <= a) = 0$.

  + Nếu $-10000 <= a < 5000$ thì $P(Y <= a) = P(Y = -10000) = 1/2$.

  + Nếu $5000 <= a < 10000$ thì $P(Y <= a) = P(Y = -10000) + P(Y = 5000) = 3/4$.

  + Nếu $a >= 10000$ thì $P(Y <= a) = 1$.

  Vậy

  $
    F_Y(a) = cases(
      0 & "nếu " a < -10000,
      1/2 & "nếu " -10000 <= a < 5000,
      3/4 & "nếu " 5000 <= a < 10000,
      1 & "nếu " a >= 10000
    ).
  $
]
#baitoan[
  Cho $P$ là độ đo Lebesgue trên $[0,1]$. Đặt

  $
    f(x) = cases(
      1 & "nếu " 0 <= x < 1/4,
      2x^2 & "nếu " 1/4 <= x < 3/4,
      x^2 & "nếu " 3/4 <= x <= 1
    )
  $

  Tính $P(f in A)$ với $A = [0,1]$ và $A = [1/2,1]$.
]

#loigiai[
  Theo định nghĩa, ta có

  $
    P(f in A) = P(f^(-1)(A)) = m(f^(-1)(A)),
  $

  với $m$ là độ đo Lebesgue.

  *a)* Với $A = [0,1]$, xét các trường hợp:

  - Nếu $0 <= x < 1/4$ thì $f(x) = 1 in A$.
  - Nếu $1/4 <= x < 3/4$ thì $f(x) in A <=> 0 <= 2x^2 <= 1 <=> 1/4 <= x <= 1/sqrt(2)$.
  - Nếu $3/4 <= x <= 1$ thì $f(x) = x^2 in A$.

  Do đó

  $
    f^(-1)([0,1])
    = [0,1/sqrt(2)] union [3/4,1].
  $

  Suy ra

  $
    P(f in [0,1])
    = m([0,1/sqrt(2)]) + m([3/4,1])
    = 1/sqrt(2) + 1/4.
  $

  *b)* Với $A = [1/2,1]$, xét các trường hợp:

  - Nếu $0 <= x < 1/4$ thì $f(x) = 1 in A$.
  - Nếu $1/4 <= x < 3/4$ thì $f(x) in A <=> 1/2 <= 2x^2 <= 1 <=> 1/2 <= x <= 1/sqrt(2)$.
  - Nếu $3/4 <= x <= 1$ thì $f(x) = x^2 in A$.

  Do đó

  $
    f^(-1)([1/2,1])
    = [0,1/4) union [1/2,1/sqrt(2)]
      union [3/4,1].
  $

  Suy ra

  $
    P(f in [1/2,1])
    = 1/4 + (1/sqrt(2) - 1/2) + 1/4
    = 1/sqrt(2).
  $
]

==== Dạng 2. Chứng minh một hàm là biến ngẫu nhiên
#ly-thuyet[
Sử dụng định nghĩa: Hàm $f: Omega -> RR$ là biến ngẫu nhiên khi và chỉ khi
$(f <= a) = f^(-1)((-infinity, a])$ là một tập đo được (thuộc $cal(M)$ với mọi $a$). Trường hợp $Omega = RR$ thì ta chọn $cal(M) = cal(B)(RR)$.
]
#baitoan[Chứng minh ánh xạ $X$ là b.n.n. Cho không gian xác suất $Omega,cal(M),P$ và ánh xạ $ X: Omega -> RR $ cho bởi $ X(w)=a , forall w in Omega, "a là hằng số thuộc R". $]

#chungminh[
  
  $X$ là bnn. Ta cần chứng minh : $(X in (-infinity,b])=(X<=b)in cal(M),forall b in RR$.

  Với $b in RR $ bất kỳ, ta có:
  $
  (X<=b)=X^(-1)((-infinity,b])={omega in Omega : X(omega) <=b}={omega in Omega : a<=b}
  
  $
  Nếu $a<=b$ thì:
  $
  (X<=b)={omega in Omega : a<=b}=Omega inter cal(M)
  $
  Nếu $b<a$ thì:
  $
  (X<=b)={omega in Omega : a<=b}=emptyset in cal(M).
  $
  Vậy, $(X<=b)=(X in (-infinity,b]) in cal(M),forall b in RR$ cho nên $X$ là bnn.

]

#baitoan[
  Cho không gian đo $(Omega, cal(M))$, $c in RR$. Xét $X(omega) = c$.

  Chứng minh $X$ là biến ngẫu nhiên. Tìm và vẽ đồ thị hàm $F_X$.
]

#loigiai[
  Để chứng minh $X$ là b.n.n, ta lấy bất kỳ $x in RR$, ta chứng minh
  $
  E={omega in Omega : X(omega)=c<= x} in cal(M)
  $
  Thật vậy, với $x$ bất kỳ $in RR$.

  Nếu $c<=x$, thì $E=Omega in cal(M)$.

  Nếu $c>x$, thì $E= emptyset in cal(M)$. 

  Vậy, trong cả $2$ trường hợp, ta đều có $E in cal(M)$, nên $X$ là b.n.n

  Hơn nữa, ta có $F_X(x)=P(X<=x)=P(E_X)$. Từ kết quả trên,
  $
  E_X=cases(emptyset : x<c,
Omega : x>=c)
  $
  Vì $P(Omega)=1$ và $P(emptyset)=0$, nên
  $
  F_X(x)=cases(0 : x<c , 1: x>=c)
  $
  
]
#baitoan[
  Cho không gian đo $(Omega, cal(M))$, $p in (0,1)$. Giả sử $A subset.eq Omega$. Đặt

  $
    1_A(omega) = cases(
      1quad & omega in A,
      0quad & omega in.not A
    )
  $

  Chứng minh rằng $1_A$ là biến ngẫu nhiên khi và chỉ khi $A in cal(M)$. Tìm và vẽ đồ thị hàm $F_(1_A)$, biết $P(A) = p$.
]
#loigiai[

  *(=>)* Đặt $1_A=X$, khi đó giả sử $X$ là b.n.n thì với bất kỳ $t in RR$, ta đều có
  $
  E_t={omega in Omega : X(omega)<=t}.
  $
  Xét $t=1/2$ bất kỳ $in RR$, khi đó có 
  $
  E_2={omega in Omega : X(omega)<=1/2}.
  $
  Ta cần chỉ ra $A in cal(M)$.

  Nếu $w in A$, thì $X(w)=1 >1/2$ nên $w in.not E_(1/2)$.

  Nếu $w in.not A$, thì $X(w)=0<1/2$ nên $w in E_(1/2)$.
  Nên $E_(1/2)=A^c$. Mà $E_(1/2) in cal(M)$, nên $A^c in cal(M) => A in cal(M)$.

  *(<=)* Giả sử $A in cal(M)$, ta chứng minh $X$ là b.n.n. Thật vậy, cho trước $t in RR$, ta chứng minh 
  $
  E={omega in Omega : X(omega)<=t} in cal(M)
  $
  Nếu $t<0$, thì $E=emptyset$.

  Nếu $0<=t<1$ , thì $E=A^c$.

  Nếu $t>=1$, thì $E=Omega$.

  Vậy, $
  E_t=cases(emptyset : t<0,
A^c : 0<=t<1,
Omega : t>=1)
  $
  Do đó, $
  F_(X)(x)=P(X<=x)=cases(0 : x<0,1-p : 0<=x<1,
1: x>=1)
  $
]
#baitoan[
  Cho không gian đo $(Omega, cal(M))$. Giả sử $A,B in cal(M)$ với $A inter B = emptyset$. Đặt $C = Omega backslash (A union B)$ và

  $
    X(omega) = cases(
      1quad & omega in A,
      3quad & omega in B,
      2quad & omega in.not (A union B)
    )
  $

  Chứng minh rằng $X$ là biến ngẫu nhiên. Tìm và vẽ đồ thị hàm $F_X$ nếu $P(A) = 1/4$, $P(B) = 1/2$.
]
#loigiai[
  Cho trước $t in RR$, ta chứng minh
  $
  E_t={omega in Omega : X(omega)<=t} in cal(M)
  $
  Nếu $t<1$, thì $E_t=emptyset$.

  Nếu $1<=t<2$, thì $E_t=A$.

  Nếu $2<=t<3$, thì $E_t=A union (A union B)^c=B^c$

  Nếu $t>=3$, thì $E_t= Omega$.

  Vậy, 
  $
  E_t=cases(emptyset &: t<1,
A &: 1<=t<2,(A union B)^c &: 2<=t<3, Omega &: t>=3)
  $
  Vì $A,B in cal(M)$, khi đó $B^c in cal(M)$. Vậy, ta luôn có $E_t in cal(M)$. Nên $X$ là b.n.n

  Từ $P(A)=1/4$ và $P(B)=1/2$, suy ra $P(B)^c=1-1/2=1/2$.

  Vậy, 
  $
  F_(X)(x)=P(X<=x)=cases( 0 &:x<1,1/4 &: 1<=x<2,
1/2 &: 2<=x<3 ,
1 &: x>=3)
  $
]

#baitoan[
  Cho $x_1, x_2 in RR$, $x_1 < x_2$. Cho biến ngẫu nhiên $X: Omega -> RR$, $P(X = x_1) = p_1$, $P(X = x_2) = p_2$ (hằng số), $p_1, p_2 > 0$, $p_1 + p_2 = 1$. Tìm hàm phân phối xác suất của $X$.
]
#loigiai[
  Ta có, $F_(X)(x)=P(X<=x)$. Vì $p_1+p_2=1$, nên các $x in RR$ ngoài $x_1,x_2$ đều có $P(x)=0$. Do đó, với bất kỳ $x in RR$

  $
  F_(X)(x)=cases(0 &: x<x_1,
p_1 &: x_1<=x<x_2,1 &: x>=x_2).
  $
]
#baitoan[
  Cho $A_1, A_2, dots, A_n in cal(M)$,
  $c_j in RR backslash {0}$,
  $A_i inter A_j = emptyset$, $c_i != c_j$
  với $i != j$.

  Đặt

  $
    X(omega) = sum_(j=1)^n c_j 1_(A_j)(omega).
  $

  Chứng minh rằng $X$ là một biến ngẫu nhiên.
]

#loigiai[
  Theo định nghĩa hàm chỉ thị, ta có

  $
    1_(A_j)(omega) = cases(
      1 & "nếu " omega in A_j,
      0 & "nếu " omega in.not A_j
    ).
  $

  Do các tập $A_1, dots, A_n$ đôi một rời nhau, suy ra

  $
    X(omega) = cases(
      c_1 & "nếu " omega in A_1,
      c_2 & "nếu " omega in A_2,
      dots.v & dots.v,
      c_n & "nếu " omega in A_n,
      0 & "nếu " omega in.not union.big_(j=1)^n A_j
    ).
  $

  Đặt

  $
    A_0 = Omega backslash union.big_(j=1)^n A_j,
    quad c_0 = 0.
  $

  Vì $A_1, dots, A_n in cal(M)$ và $cal(M)$ là một $sigma$-đại số nên $A_0 in cal(M)$. Hơn nữa, các tập $A_0,A_1,dots,A_n$ đôi một rời nhau và

  $
    union.big_(j=0)^n A_j = Omega.
  $

  Xét tập $D = {c_0,c_1,dots,c_n}$. Do các $c_j$ đôi một khác nhau và $D$ hữu hạn, không mất tính tổng quát, ta đánh lại chỉ số đồng thời của các cặp $(c_j,A_j)$ thành $(d_j,B_j)$ sao cho

  $
    d_0 < d_1 < dots < d_n.
  $

  Khi đó $X(omega)=d_j$ nếu $omega in B_j$, với $j=0,dots,n$.

  Cho trước $t in RR$, ta cần chứng minh

  $
    E_t = {omega in Omega : X(omega) <= t}
    in cal(M).
  $

  Vì các giá trị của $X$ được sắp xếp theo thứ tự tăng dần, ta có

  $
    E_t = cases(
      emptyset & "nếu " t < d_0,
      B_0 & "nếu " d_0 <= t < d_1,
      B_0 union B_1 & "nếu " d_1 <= t < d_2,
      dots.v & dots.v,
      union.big_(j=0)^(n-1) B_j
        & "nếu " d_(n-1) <= t < d_n,
      Omega & "nếu " t >= d_n
    ).
  $

  Tổng quát, với $d_k <= t < d_(k+1)$,
  $k=0,dots,n-1$, ta có

  $
    E_t = union.big_(j=0)^k B_j.
  $

  Vì $B_j in cal(M)$ với mọi $j=0,dots,n$, và $cal(M)$ đóng dưới phép hợp hữu hạn, nên trong mọi trường hợp ta đều có

  $
    E_t in cal(M), quad forall t in RR.
  $

  Theo định nghĩa, $X$ là một biến ngẫu nhiên.
]

  
#baitoan[
  Cho $(Omega, cal(M), P)$ và $A in cal(M)$ với $p = P(A)$. Chứng minh $X$ là biến ngẫu nhiên và tìm hàm phân phối tích lũy của $X$ với

  $
    X(omega) = cases(
      c quad & omega in A,
      b quad & omega in.not A
    )
  $

  trong trường hợp $c = 1$, $b = 0$. Trường hợp $c = 2$, $b = 1$ thì sao? Khảo sát trường hợp tổng quát với $c,b$ bất kỳ.
]

#loigiai[

  Lấy bất kỳ $t in RR$, ta chứng minh
  $
  E_t={ omega in Omega : X(omega)<=t} in cal(M)
  $
  Thật vậy, với $c=1$ và $b=0$, thì $
  X(omega)=cases(1 &: omega in A, 0 &: omega in.not A)
  $
  Do đó, nếu $t<0$, thì $E_t=emptyset$ và nếu $0<=t<1$, thì $E_t=A^c$.Và $t>=1$, thì $E=Omega$.

  Do đó, $
  E_t=cases(emptyset &: t<0, A^c &: 0<=t<1, Omega &: t>=1)
  $
  Với $p(A)=p => p(A^c)=1-p$, hơn nữa $
  
  F_X(x)=P(X<=x)=cases(0 &: x<0, 1-p &:0<=x<1,1 &:x>=1)
  $
  Với $c,b$ bất kỳ thuộc $RR$, không mất tính tổng quát, ta có thể giả sử $c>b$. Khi đó chứng minh tương tự như trên, ta đều thu được
  $
  E_t=cases(emptyset &: t<b, A^c &: b<=t<c , Omega &: t>=c).
  $
  Suy ra, $
  F_(X)(x)=P(X<=x)=cases(0 &: x<b, 1-p &: b<=x<c, 1&:x>=c)
  $
  Nếu $c<b$, thì $
  E_t=cases(emptyset &: t<c, A &: c<=t<b, Omega &:t>=b)
  $
  Suy ra,
  $
  F_(X)(x)=P(X<=x)=cases(0 &: x<c ,p &:c<=x<b , 1 &:x>=b)
  $
  Nếu $b=c$, thì tương tự bài toán $2.16$. Thật ra, ta có thể biểu diễn hàm phân phối mà không cần chia trường hợp.
  $
  F_(X)(t)=p cal(1)_[c,infinity)(t) +(1-p) cal(1)_[b,infinity)(t)
  $
  Và độ đo phân phối là,
  $
  mu(X)=p delta_c + (1-p) delta_b
  $
]
#baitoan[
  Ta nói $f: RR -> RR$ là đo được Borel nếu $(f <= a) in cal(B)(RR)$, $forall a in RR$.

  Chứng minh rằng hàm $f: RR -> RR$, $f(x) = 2x$ là đo được Borel trên $RR$. Có cách chứng minh nào khác không?
]
#loigiai[
  Để chứng minh $f$ đo được Borel trên $RR$, ta chứng minh với tùy ý $a in RR$, $(f<=a) in cal(B(RR))$. Thật vậy, cho trước $a in RR$, ta chứng minh $(f<=a)in cal(B(RR))$. Với $f(x)=2 x$, thì $f(x)<= a<=> 2x<=a <=> x<=a/2 <=> x in (-infinity,a/2]$, Vì tập $(-infinity,a/2] in cal(B(RR))$, nên tập $(f<=a) in cal(B(RR))$. Vậy $f(x)=2 x$ đo được Borel trên $RR$. 
  
  *Cách 2. Sử dụng tính liên tục.*

  Ta có $f(x) = 2x$ liên tục trên $RR$.

  Với mọi tập mở $U subset.eq RR$, do $f$ liên tục nên tiền ảnh $f^(-1)(U)$ là tập mở trong $RR$. Suy ra
  $
    f^(-1)(U) in cal(B)(RR).
  $

  Đặt
  $
    cal(D) = {B subset.eq RR : f^(-1)(B) in cal(B)(RR)}.
  $

  Ta chứng minh $cal(D)$ là một $sigma$-đại số trên $RR$.

  - Vì $f^(-1)(RR) = RR in cal(B)(RR)$ nên $RR in cal(D)$.

  - Nếu $B in cal(D)$, thì
    $
      f^(-1)(B^c) = (f^(-1)(B))^c in cal(B)(RR).
    $
    Do đó $B^c in cal(D)$.

  - Nếu $B_n in cal(D)$ với mọi $n in NN^+$, thì
    $
      f^(-1)(union.big_(n=1)^infinity B_n)
      = union.big_(n=1)^infinity f^(-1)(B_n)
      in cal(B)(RR).
    $
    Suy ra $union.big_(n=1)^infinity B_n in cal(D)$.

  Vậy $cal(D)$ là một $sigma$-đại số chứa tất cả các tập mở của $RR$.

  Mặt khác, $cal(B)(RR)$ là $sigma$-đại số nhỏ nhất chứa tất cả các tập mở của $RR$, nên
  $
    cal(B)(RR) subset.eq cal(D).
  $

  Do đó, với mọi $B in cal(B)(RR)$, ta có
  $
    f^(-1)(B) in cal(B)(RR).
  $

  Vậy $f(x) = 2x$ là hàm đo được Borel trên $RR$.
]

  *Cách 3. Sử dụng tính đơn điệu.*

  Ta có $f(x) = 2x$ là hàm tăng nghiêm ngặt trên $RR$.

  Ta sử dụng kết quả: Mọi hàm đơn điệu từ $RR$ vào $RR$ đều đo được Borel.

  Thật vậy, giả sử $g: RR -> RR$ là hàm không giảm.

  Với mỗi $a in RR$, xét tập
  $
    E_a = {x in RR : g(x) <= a}.
  $

  Vì $g$ không giảm nên nếu $x in E_a$ và $y < x$, thì
  $
    g(y) <= g(x) <= a,
  $
  suy ra $y in E_a$.

  Như vậy, $E_a$ là tập đóng về phía trái, nên có một trong các dạng
  $
    emptyset, quad RR, quad (-infinity,c), quad (-infinity,c]
  $
  với $c in RR$.

  Các tập trên đều thuộc $cal(B)(RR)$, do đó
  $
    E_a in cal(B)(RR), quad forall a in RR.
  $

  Suy ra $g$ đo được Borel.

  Trường hợp $g$ không tăng được chứng minh tương tự, khi đó $E_a$ là tập đóng về phía phải, có dạng $emptyset$, $RR$, $(c,+infinity)$ hoặc $[c,+infinity)$.

  Vì $f(x) = 2x$ là hàm tăng nghiêm ngặt trên $RR$, nên $f$ đo được Borel.
#baitoan[
  Tương tự bài 7 với $f(x)$ là $2x+1$, $e^x$, $-3x$, $x^3+1$.
]
#loigiai[

  Dễ thấy, vì $f(x)$ đều là các hàm liên tục trên $RR$. Nên ta có $f$ đo được Borel trên $RR$.
]
#baitoan[
  Cho $f(x) = x^2$. Hỏi $f$ có đo được Borel hay không? Hãy kiểm tra trực tiếp bằng cách sử dụng tính chất (E):

  Hàm $f: X -> [-infinity, infinity]$ đo được khi và chỉ khi $(f <= a)$ đo được với mọi $a in RR$.
]
#loigiai[

  Nếu sử dụng định lý về các hàm liên tục trên $RR -> RR$, thì ta thấy ngay $f(x)=x^2$ liên tục trên $RR -> RR$, nên $f$ đo được Borel.

  Ta chứng minh $f : X -> RR$ đo được Borel. Thật vậy, cho trước $a in RR$, ta chứng minh $(f<=a) in cal(B(RR))$.

  Nếu $a<0$, thì ${f<=a} ={x in RR :x^2 <a<0}=emptyset in cal(B(RR))$.

  Nếu $a>=0$ , thì ${f<=a} =[-sqrt(a),sqrt(a)] in cal(B(RR))$.

  Suy ra, $(f<=a) in cal(B(RR))$, nên $f$ đo được Borel.
]

==== Dạng 3. Tính chất phân phối $P(Y in B)$ và hàm $F_Y (y) = P(Y <= y)$
#ly-thuyet[
Ta có $P_Y (B) = P(Y in B)$.

Nếu $Y: Omega -> RR$ thì $P(X in (a,b))$ sẽ ghi là $P(a < X < b)$, v.v.
]

#baitoan[
  Cho biến ngẫu nhiên $X$, viết các biểu thức sau dưới dạng hàm phân phối tích lũy của $X$.

  (a) $F_(3X-2)(y)$, $F_(-5X+4)(y)$.

  (b) $F_(X^2)(y)$, $F_(X^3)(y)$.

  (c) $F_(e^X)(y)$, $F_(ln X)(y)$.
]

#loigiai[
  
  *a)* Theo định nghĩa hàm phân phối tích lũy, ta có
  $
    F_(3X-2) (y)
    &= P(3X-2 <= y) \
    &= P(X <= (y+2)/3) \
    &= F_X ((y+2)/3).
  $

  Tương tự,
  $
    F_(-5X+4) (y)
    &= P(-5X+4 <= y) \
    &= P(X >= (4-y)/5) \
    &= 1-P(X < (4-y)/5) \
    &= 1-F_X (((4-y)/5)^(-)).
  $

  *b)* Ta có
  $
    F_(X^2) (y) = P(X^2 <= y).
  $

  Nếu $y < 0$, do $X^2 >= 0$ nên
  $
    F_(X^2) (y) = 0.
  $

  Nếu $y >= 0$, ta có
  $
    X^2 <= y
    <=> -sqrt(y) <= X <= sqrt(y).
  $

  Do đó,
  $
    F_(X^2)(y)
    &= P(-sqrt(y) <= X <= sqrt(y)) \
    &= F_X (sqrt(y)) - F_X ((-sqrt(y))^(-)).
  $

  Suy ra,
  $
    F_(X^2) (y) = cases(
      0 & "nếu" y < 0,
      F_X (sqrt(y)) - F_X((-sqrt(y))^(-)) & "nếu" y >= 0.
    )
  $

  Mặt khác, vì hàm $x^3$ tăng nghiêm ngặt trên $RR$, nên
  $
    F_(X^3) (y)
    &= P(X^3 <= y) \
    &= P(X <= root(3,y)) \
    &= F_X (root(3,y)).
  $

  *c)* Ta có
  $
    F_(e^X) (y) = P(e^X <= y).
  $

  Nếu $y <= 0$, do $e^X > 0$ nên
  $
    F_(e^X) (y) = 0.
  $

  Nếu $y > 0$, vì hàm $e^x$ tăng nghiêm ngặt trên $RR$, nên
  $
    e^X <= y <=> X <= ln y.
  $

  Do đó,
  $
    F_(e^X) (y) = F_X (ln y).
  $

  Suy ra,
  $
    F_(e^X) (y) = cases(
      0 & "nếu" y <= 0,
      F_X (ln y) & "nếu" y > 0.
    )
  $

  Cuối cùng, giả sử $X > 0$ hầu chắc chắn để $ln X$ xác định như một biến ngẫu nhiên thực (sau khi điều chỉnh trên tập không nếu cần).

  Vì hàm $ln x$ tăng nghiêm ngặt trên $(0,+infinity)$, nên
  $
    F_(ln X) (y)
    &= P(ln X <= y) \
    &= P(0 < X <= e^y) \
    &= F_X (e^y) - F_X (0) \
    &= F_X (e^y).
  $

  Vậy,
  $
    F_(ln X) (y) = F_X (e^y), quad forall y in RR.
  $
]


#baitoan[
  Cho biến ngẫu nhiên $X$, viết các biểu thức sau dưới dạng hàm phân phối tích lũy của $X$.

  (a) $P(4 < X^2 < 16)$, $P(1 < X^3 < 8)$.

  (b) $P(4 < e^X < 16)$, $P(1 < e^(X^3) < 8)$.
]

#loigiai[
  
  *a)* Ta có
  $
    4 < X^2 < 16
    <=> 2 < |X| < 4
    <=> X in (-4,-2) union (2,4).
  $

  Vì hai khoảng trên rời nhau nên
  $
    P(4 < X^2 < 16)
    &= P(-4 < X < -2) + P(2 < X < 4) \
    &= F_X ((-2)^(-)) - F_X (-4)
       + F_X (4^(-)) - F_X (2).
  $

  Mặt khác, vì hàm $x^3$ tăng nghiêm ngặt trên $RR$, nên
  $
    1 < X^3 < 8 <=> 1 < X < 2.
  $

  Do đó,
  $
    P(1 < X^3 < 8) = F_X (2^(-)) - F_X (1).
  $

  *b)* Vì hàm $e^x$ tăng nghiêm ngặt trên $RR$, ta có
  $
    4 < e^X < 16
    <=> ln 4 < X < ln 16.
  $

  Suy ra,
  $
    P(4 < e^X < 16)
    = F_X ((ln 16)^(-)) - F_X (ln 4).
  $

  Tương tự,
  $
    1 < e^(X^3) < 8
    &<=> 0 < X^3 < ln 8 \
    &<=> 0 < X < (ln 8)^(1/3).
  $

  Do đó,
  $
    P(1 < e^(X^3) < 8)
    = F_X (((ln 8)^(1/3))^(-)) - F_X (0).
  $
]

==== Dạng 4. Phân tích hàm phân phối tích lũy
#ly-thuyet[
*Bước 1:* Ta tìm $D_X$, tập hợp các điểm gián đoạn của hàm xác suất tích lũy $F_X$.

*Bước 2:* Tính $P(X = z)$ với $z in D_X$ và viết hàm

$
  F(x) = sum_(z in D_X) P(X = z) 1_([z, infinity))(x)
$

*Bước 3:* Tìm hàm $G(x) = F_X(x) - F(x)$.
]
#baitoan[
  Phân tích thành phần rời rạc và phần liên tục các hàm sau

  $
    F_X(x) = cases(
      0 quad& x < 0,
      0.4x + 0.1 quad& 0 <= x < 1/2,
      0.9x & 1/2 <= x < 1,
      1 & x >= 1
    )
  $

  Viết công thức tính $lambda_X(A) = P(X in A)$ với $A in cal(B)(RR)$.

  Áp dụng tính $P(X in A)$ với
  $A = (1/4, 3/4) union (1, infinity)$.
]
#loigiai[
Có $D_X={0,1/2,1}$. Và $P(0)=0.1,P(1/2)=0,15,P(1)=0,1$. Do đó, $

F(x)=sum_(x in D_X) P(X= z) cal(1)_[x, infinity) (x)&=P(X=0) cal(1)_[0,infinity)(x)+P(X=1/2) cal(1)_[1/2,infinity](x) +P(X=1)cal(1)_[1,infinity](x)\
&=cases(0 &: x<0,0.1 &: 0<=x<1/2, 0.25 &: 1/2<=x<1 ,0.35 &: x>=1).

$
Do đó, $lambda_(X) (A)=P(X=0) delta_0(A) + P(X=1/2) delta_(1/2)( A)+P(X=1) delta_(1)(A). + integral_A g(x) d x$. Với $
g(x)= G'(x)=cases( 0.4 &: 0<=x<1/2 , 0.9 &: 1/2<=x<1 , 0 &: "Các trường hợp còn lại.")
$

Hơn nữa, $
G(x)=F_(X) (x)-F(x)=cases(0 &: x<0 , 0.4x &: 0<=x<1/2 , 0.9x-0.25 &: 1/2<=x<1, 0.65 &: x>=1 )
$

Khi đó, $P(X in A)= 0.15 +integral_(1/4)^(1/2) 0.4 d x +integral_(1/2)^(3/4) 0.9 dif x=19/40$. 
]

#baitoan[
  Phân tích thành phần rời rạc và phần liên tục các hàm sau

  $
    F_X(x) = cases(
      0quad & x < 0,
      0.4x^2 + 0.1 quad& 0 <= x < 1/2,
      0.45x quad& 1/2 <= x < 2,
      1 - 1/(1 + 10x^2) quad& x >= 2
    )
  $

  Viết công thức tính $lambda_X(A) = P(X in A)$ với $A in cal(B)(RR)$.

  Áp dụng tính $P(X in A)$ với
  $A = (1/2, 1/4) union (1, infinity)$.
]
#loigiai[

  Ta có tập các điểm gián đoạn của $F_(X)(x)$ là $D_X={0,1/2,2}$. Hơn nữa, có $P(0)=0.1,P(1/2)=0.025,P(2)=0.075$ do đó thành phần rời rạc của $F_X (x) $ là :
  $
  F(x)&=P(X=0) 1_[0,infinity) (x) +P(X=1/2) 1_[1/2,infinity)(x) + P(X=2) 1_[2,infinity) (x)
  \
  &=cases(0 &: x<0,
0.1 &: 0<=x<1/2,
0.125 &: 1/2<=x<2,
0.2 &: x>=2)
  $
  Do đó, thành phần liên tục là 
  $
  G(x)=F_(X) (x)-F(x)=cases(0 &:x<0,0.4 x^2 &: 0<=x<1/2,0.45x-0.125 &: 1/2<=x<2,0.8 -1/(1+10x^2)&: x>=2)
  $
  Suy ra, $
  g(x)=G'(x)=cases(0 &: x<0 , 0.8 x &:0<=x<1/2, 0.45 &: 1/2<=x<2,(20 x)/(1+10x)^2 &: x>=2)
  $
  Do đó, $
  lambda_(X) (A)=P(X in A)=0.1 times delta_0(A) +0.025 times delta_(1/2) (A)+0.075 times delta_(2) (A)+integral_A g(x) dif x
  $
  Do đó, với $A=(1/2,1/4)union (1,infinity)=(1,infinity)$, thì 
  $
  P(X in A)=P(X>1)=1-(P(X<=1))=1-F_X (1)=1-0.45=0.55
  $
  Cách khác, có $
  P(X in A)=0.075 + integral_1^2 0.45 x dif x+integral_2 ^infinity (20 x)/(1+10x)^2 dif x=0.55
  $
]

==== Dạng 5. Tính chất biến ngẫu nhiên (định hướng lý thuyết)
#ly-thuyet[
Cho $Omega$ là một không gian mẫu và $cal(M)$ là tập các biến cố của $Omega$. Để chứng minh một hàm $X: Omega -> RR$ là một biến ngẫu nhiên, ta cần chứng minh $(X <= a) in cal(M)$ với mọi $a in RR$.
]
#baitoan[
  Cho $B_i$, $i in I$, $B,C$ là các tập con của $Y$ và cho ánh xạ $f: X -> Y$. Khi đó $
  (f in Y) = X
  $ và

  $
    (f in union.big_(i in I) B_i)
    = union.big_(i in I) (f in B_i)
  $

  $
    (f in inter.big_(i in I) B_i)
    = inter.big_(i in I) (f in B_i)
  $

  $
    (f in B backslash C)
    = (f in B) backslash (f in C)
  $
]
#loigiai[

  *a)* Có $(f in Y) = { x in X : f(x) in Y}=X$.

  *b)* Có $(f in union.big_(i in I) B_i)={x in X : f(x) in union.big _(i in I) B_i}$. Khi đó lấy $
  x in (f in union.big_(i in I) B_i)<=> exists i in I : f(x)in union.big B_i <=> i in I : x  in (f in B_i)<=> x in union.big _(i in I) (f in B_i)
  $

  *c)* Có $(f in inter.big_(i in I) B_i)={ x in X:f(x) in inter.big_(i in I) B_i}$. Khi đó, lấy $x in X$, có
  $
  x in (f in inter.big_(i in I) B_i)<=> forall i in I : f(x) in B_i <=> forall i in I: x in (f in B_i)<=> x in inter.big_(i in I) (f in B_i).
  $

  *d)*

  Có $(f in B backslash C)={ x in X : f(x) in B "và" f(x) in.not C}$. Khi đó, với $x in X$, có
  $
  x in (f in B backslash C) <=> x in f(B) "và" x in.not f(C) <=> x in (f in B) backslash (f in C).
  $
  
]
#baitoan[
  Cho $X: Omega -> RR$ thỏa
  $X(Omega) = {x_1, dots, x_n}$ với
  $x_i != x_j$ khi $i != j$.

  Chứng minh

  $
    X(omega) = sum_(j=1)^n x_j 1_((X = x_j))(omega)
  $

  Từ đó chứng minh $X$ là biến ngẫu nhiên khi và chỉ khi $(X = x_j) in cal(M)$ với mọi $j = overline(1:n)$.
]
#loigiai[

  Đặt $A_i=(X=x_i)={omega in Omega : X(omega)=x_i}$. Khi đó,
  $
  1_(A_i)(omega)=cases(1 &: omega in A_i ,0&: omega in.not A_i).
  $
  Do đó, lấy $omega in Omega$ tùy ý, suy ra luôn có $k in {1,2,...,n}$ sao cho $X(omega)=x_k$. Hơn nữa,
  $
  sum_(i=1)^n x_i 1_(A_i) (omega)=x_k=X(omega)
  $
  Vậy, ta có điều phải chứng minh.

  Giả sử $X$ là biến ngẫu nhiên, khi đó ta chứng minh $(X=x_j) im cal(M),forall j=overline(1:n)$.

  Vì $X$ là biến ngẫu nhiên, khi đó $
  forall t in RR, E_t=X^(-1) (-infinity,t]=(X<=t)={omega in Omega : X(omega)<=t} in cal(M).
  $
  Do đó, xét $t=x_1$ , ta được
  $
  E_t={omega in Omega : X(omega)<=x_1} in cal(M)
  $
  Theo câu a), $X(omega)=sum_(i=1)^n x_i 1_(A_i)(omega)<= x_i => X(omega)=x_i <=> E_t={omega in Omega : X(omega)=x_i<=t} in cal(M)$. Tương tự, khi xét các $x "khác" x_1$. Do đó, $(X=x_i) in cal(M),forall i=overline(1:n)$.

  Giả sử $(X=x_i) in cal(M),forall i=overline(1:n)$. Khi đó, ta chứng minh $X$ là b.n.n. Cho trước $t in RR$, ta chứng minh
  $
  E_t={omega in Omega : X(omega)<=t}in cal(M)<=> {omega in Omega : sum_(i=1)^n x_i 1_(A_i) (omega) <=t}in cal(M)
  $
  Vì các $x_1,x_2,...x_n$ đôi  một khác nhau, nên ta sẽ đánh số lại sao cho $x_1<x_2<...<x_n$. Khi đó, nếu $t<x_1$, thì $E_t= emptyset$,.... có
  $
  E_t=cases( emptyset &: t<x_1 ,(X=x_1) &: x_1<=t<x_2,(X=x_1)union(X=x_2) &: x_2<=t<x_3, dots, Omega &:t>=x_n).
  $
  Hơn nữa, do $cal(M)$ đóng với phép hợp hữu hạn nên trong các trường hợp, ta đều có $E_t in cal(M)$. Vậy $X$ là b.n.n.
]
#baitoan[
  Hàm $f: Omega -> (-infinity, infinity]$ là một biến ngẫu nhiên (đo được) nếu và chỉ nếu một trong các điều sau là đúng với mọi $a in RR$:

  (a) $(f >= a) := f^(-1)([a, infinity))$ đo được.

  (b) $(f > a) := f^(-1)((a, infinity))$ đo được.

  (c) $(f <= a) := f^(-1)((-infinity, a])$ đo được.

  (d) $(f < a) := f^(-1)((-infinity, a))$ đo được.

  (e) $(f in (a,b)) := f^(-1)((a,b))$ đo được với mọi $a < b$.
]

#baitoan[
  Cho dãy biến ngẫu nhiên $f_n: X -> (-infinity, infinity)$. Khi đó $sup f_n$, $inf f_n$, $limsup f_n$, $liminf f_n$ là biến ngẫu nhiên.
]

#baitoan[
  Chứng minh rằng mọi ánh xạ liên tục $f: RR -> RR$ đều là hàm Borel đo được.
]
#pagebreak()
=== Các tham số đặc trưng

=== Dạng 1. Các phép toán trung bình $E(Y)$
#ly-thuyet[
Ta có các tính chất:

$
  E(a X + b Y) = a E(X) + b E(Y)
$

$
  E(X) <= E(Y) quad "nếu" X <= Y
$

$
  E(c) = c.
$
]
#baitoan[
Cho biết
  $
    E(X^2) = 1, quad E(Y^2) = 16,
    quad E(X Y) = -3, quad E(Y) = 2.
  $

  Tính
  $
    E((X+2Y)^2), quad E((2Y+3)^2).
  $
]
#loigiai[

  Có $E((X+2Y)^2)=E(X^2+4X Y+4Y^2)=E(X^2)+E(4 X Y)+E(4 Y^2)=1+4times-3+4 times 16=53 .$

  $E((2Y+3)^2)=E(4 Y^2+ 12 Y+9)= 4 E(Y^2)+12 E(Y)+9=97$.
]
#baitoan[
 Cho biết
  $
    E(X^2) = alpha, quad
    E(Y^2) = beta, quad
    E(X Y) = gamma.
  $

  Tính
  $
    E((X+Y)(X-3Y)).
  $
]
#loigiai[
  Có $
  E((X+Y)(X-3 Y))=E(X^2-2X Y- 3 Y^2)=E(X^2)-2 E(X Y)- 3 E(Y^2)=alpha-2gamma-3beta
  $
]
#baitoan[
 Chứng minh các mệnh đề về phương sai $ "var" $ và hiệp phương sai $ "cov" $.
]

#loigiai[
  Giả sử $X, Y$ là hai biến ngẫu nhiên có moment bậc hai hữu hạn.

  *1. Công thức phương sai*

  Theo định nghĩa,
  $ op("Var")(X) = E((X - E(X))^2). $

  Khai triển và sử dụng tính tuyến tính của kỳ vọng, ta có
  $
    op("Var")(X)
    &= E(X^2 - 2X E(X) + E(X)^2) \
    &= E(X^2) - 2E(X)^2 + E(X)^2 \
    &= E(X^2) - E(X)^2.
  $

  Vậy,
  $ op("Var")(X) = E(X^2) - E(X)^2. $

  Hơn nữa, vì $(X - E(X))^2 >= 0$ nên
  $ op("Var")(X) >= 0. $

  *2. Tính chất của phương sai*

  Với mọi $a,b in RR$, ta có
  $
    op("Var")(a X+b)
    &= E((a X+b-E(a X+b))^2) \
    &= E((a X+b-a E(X)-b)^2) \
    &= E(a^2 (X-E(X))^2) \
    &= a^2 op("Var")(X).
  $

  Do đó,
  $ op("Var")(a X+b)=a^2 op("Var")(X). $

  *3. Công thức hiệp phương sai*

  Theo định nghĩa,
  $
    op("Cov")(X,Y)
    = E((X-E(X))(Y-E(Y))).
  $

  Khai triển, ta được
  $
    op("Cov")(X,Y)
    &= E(X Y-X E(Y)-Y E(X)+E(X)E(Y)) \
    &= E(X Y)-E(X)E(Y)-E(Y)E(X)+E(X)E(Y) \
    &= E(X Y)-E(X)E(Y).
  $

  Vậy,
  $ op("Cov")(X,Y)=E(X Y)-E(X)E(Y). $

  *4. Tính đối xứng của hiệp phương sai*

  Vì $X Y=Y X$, nên
  $
    op("Cov")(X,Y)
    &= E(X Y)-E(X)E(Y) \
    &= E(Y X)-E(Y)E(X) \
    &= op("Cov")(Y,X).
  $

  Do đó,
  $ op("Cov")(X,Y)=op("Cov")(Y,X). $

  *5. Mối liên hệ giữa phương sai và hiệp phương sai*

  Ta có
  $
    op("Cov")(X,X)
    &= E(X^2)-E(X)E(X) \
    &= E(X^2)-E(X)^2 \
    &= op("Var")(X).
  $

  Suy ra,
  $ op("Cov")(X,X)=op("Var")(X). $

  *6. Tính tuyến tính của hiệp phương sai*

  Với mọi $a,b in RR$, ta có
  $
    op("Cov")(a X+b,Y)
    &= E((a X+b)Y)-E(a X+b)E(Y) \
    &= a E(X Y)+b E(Y)-(a E(X)+b)E(Y) \
    &= a(E(X Y)-E(X)E(Y)) \
    &= a op("Cov")(X,Y).
  $

  Do đó,
  $ op("Cov")(a X+b,Y)=a op("Cov")(X,Y). $

  Tương tự, với biến ngẫu nhiên $Z$ có moment bậc hai hữu hạn,
  $
    op("Cov")(X+Y,Z)
    = op("Cov")(X,Z)+op("Cov")(Y,Z).
  $

  *7. Phương sai của tổng hai biến ngẫu nhiên*

  Theo định nghĩa,
  $
    op("Var")(X+Y)
    &= E((X+Y)^2)-E(X+Y)^2 \
    &= E(X^2+2X Y+Y^2)-(E(X)+E(Y))^2 \
    &= E(X^2)+2E(X Y)+E(Y^2) \
    &quad -E(X)^2-2E(X)E(Y)-E(Y)^2 \
    &= (E(X^2)-E(X)^2) \
    &quad +(E(Y^2)-E(Y)^2) \
    &quad +2(E(X Y)-E(X)E(Y)) \
    &= op("Var")(X)+op("Var")(Y)+2op("Cov")(X,Y).
  $

  Vậy,
  $
    op("Var")(X+Y)
    = op("Var")(X)+op("Var")(Y)+2op("Cov")(X,Y).
  $

  Tổng quát, với mọi $a,b in RR$,
  $
    op("Var")(a X+b Y)
    &= a^2 op("Var")(X)+b^2 op("Var")(Y) \
    &quad +2a b op("Cov")(X,Y).
  $

  *8. Trường hợp hai biến ngẫu nhiên độc lập*

  Nếu $X,Y$ độc lập thì
  $ E(X Y)=E(X)E(Y). $

  Suy ra,
  $
    op("Cov")(X,Y)
    = E(X Y)-E(X)E(Y)=0.
  $

  Vì vậy,
  $
    op("Var")(X+Y)
    = op("Var")(X)+op("Var")(Y).
  $

  Chú ý rằng chiều ngược lại không đúng trong trường hợp tổng quát: $op("Cov")(X,Y)=0$ không nhất thiết suy ra $X,Y$ độc lập.
]

#baitoan[
 Cho không gian xác suất $(Omega, cal(M), P)$.

  (a) Chứng minh
  $
    E(I_A) = P(A), quad A in cal(M).
  $

  (b) Cho biến ngẫu nhiên $X: Omega -> RR^d$.
  Chứng minh
  $
    E(I_B (X)) = P(X in B),
    quad B in cal(B)(RR^d).
  $
]
#loigiai[
  
*(a)* Cho $A in cal(M)$. Xét hàm chỉ mục $I_A: Omega -> bb(R)$ được định nghĩa bởi
$
  I_A(omega) = cases(
    1 & "nếu " omega in A,
    0 & "nếu " omega in A^c.
  )
$

Vì $A in cal(M)$ nên $I_A$ là hàm đơn giản không âm và đo được trên $(Omega, cal(M))$.

Theo định nghĩa kỳ vọng và tích phân Lebesgue của hàm đơn giản, ta có
$
  E(I_A)
  &= integral_Omega I_A(omega) dif P(omega) \
  &= 1 dot P(A) + 0 dot P(A^c) \
  &= P(A).
$



*(b)* Cho $B in cal(B)(bb(R)^d)$.

Vì $X: Omega -> bb(R)^d$ là biến ngẫu nhiên nên $X$ là ánh xạ đo được. Do đó,
$
  X^(-1)(B) in cal(M),
$
trong đó
$
  X^(-1)(B)
  = {omega in Omega : X(omega) in B}.
$

Với mọi $omega in Omega$, ta có
$
  I_B(X(omega))
  &= cases(
    1 & "nếu " X(omega) in B,
    0 & "nếu " X(omega) in.not B
  ) \
  &= cases(
    1 & "nếu " omega in X^(-1)(B),
    0 & "nếu " omega in.not X^(-1)(B)
  ) \
  &= I_(X^(-1)(B))(omega).
$

Suy ra
$
  I_B compose X = I_(X^(-1)(B)).
$

Áp dụng kết quả câu (a), ta được
$
  E(I_B(X))
  &= integral_Omega I_B(X(omega)) dif P(omega) \
  &= integral_Omega I_(X^(-1)(B))(omega) dif P(omega) \
  &= P(X^(-1)(B)) \
  &= P({omega in Omega : X(omega) in B}) \
  &= P(X in B).
$
]
#baitoan[
 Cho biến ngẫu nhiên $X$ thỏa mãn
  $
    P(X >= 0) = 1,
    quad P(X >= 10) = 1/5.
  $

  Chứng minh
  $
    E(X) >= 2.
  $
]

#baitoan[
 Hai biến ngẫu nhiên $X,Y$ gọi là không tương quan nếu
  $
    "cov"(X,Y) = 0.
  $

  Giả sử $X_1, dots, X_n$ không tương quan từng đôi một. Chứng minh
  $
    "var" (sum_(j=1)^n X_j)
    = sum_(j=1)^n "var"(X_j).
  $
]
#loigiai[

  Với $C o v(X,Y)=0 <=> E(X Y)=E(X) E(Y)$.

  Do đó, $
  V a r (sum_(j=1)^n X_j)=V a r (X_1+X_2+X_3+...+X_n)=V a r ((X_1+X_2+...)+X_n)=V a r (X_1+X_2+...X_(n-1)) + V a r(X_n)+ 2C o v (..,X_n)
  $
  Trong đó , $C o v (X_1+...X_(n-1),X_n)=0$
  Do đó, nếu lặp lại quá trình trên, ta thu được $
  V a r(sum_(j=1)^n X_j)=V a r(X_1)+V a r(X_2)+...+ V a r (X_n)=sum_(j=1)^n V a r (X_j).
  $ 
  
]
#baitoan[
 Cho $X,Y$ là hai biến ngẫu nhiên. Chứng minh
  $
    t^2 E(X^2) + 2t E(X Y) + E(Y^2) >= 0,
    quad forall t in RR.
  $

  Từ đó suy ra
  $
    |E(X Y)| <= sqrt(E(X^2) E(Y^2)).
  $
]
#loigiai[

  $forall t in RR$, đặt $k=t X+Y$, khi đó $E(k^2)>=0 <=> E(t^2 X^2 + 2t X Y+Y^2)=t^2 E(X^2)+2 t E(X Y)+E(Y^2)>= quad(1)0$. Hơn nữa, luôn có $E(X^2)>=0$, do đó, để $(1) >=0$, thì ta cần $
  triangle=E(X Y)^2-E(X^2)E(Y^2)<=0 <=> E(X Y)^2<=E(X^2) E(Y^2) <=> abs(E(X Y))<= sqrt(E(X^2) E(Y^2)).
  $
]
#baitoan[
 Chứng minh
  $
    |E(X)| <= sqrt(E(X^2)).
  $
  
]
#loigiai[

  Có $V a r(X)>= 0$. Do đó, $E(X^2)-(E(X))^2>=0$, nên $
  abs(E(X))<= sqrt(E(X^2))
  $ 
]


=== Dạng 2. Tìm các đại lượng với biến ngẫu nhiên độc lập

Tìm các đại lượng
$
  P(X_1 in A_1, dots, X_n in A_n),
$

$
  E(g_1(X_1) dots g_n(X_n)),
$

với $X_1, dots, X_n$ độc lập.

Áp dụng các công thức:

$
  P(X_1 in A_1, dots, X_n in A_n)
  = P(X_1 in A_1) dots P(X_n in A_n).
$

$
  E(g_1(X_1) dots g_n(X_n))
  = E(g_1(X_1)) dots E(g_n(X_n)).
$

#baitoan[
 Tìm hàm phân phối tích lũy của các biến sau theo $F_(X_1)$.

  (a) $Z = max(X_1, dots, X_n)$, biết $X_1, dots, X_n$ độc lập và có cùng phân phối.

  *Hướng dẫn:* $max(X_1, dots, X_n) <= z$ nghĩa là $X_1 <= z, dots, X_n <= z$.

  (b) $Z = min(X_1, dots, X_n)$, biết $X_1, dots, X_n$ độc lập và có cùng phân phối.
]
#loigiai[

  *a)* Ta có, với $z in RR$.
  $
  F_(Z) (z)=P(Z<=z)&=P(max(X_1,X_2,...,X_n)<=z)\ &=P(X_1<=z,X_2<=z,...,X_n<=z)\
  &=P(X_1<=z)...P(X_n<=z)\
  &=(F_(X) (z))^n
  $
  *b)*

  Với $z in RR$, có $
  F_(Z)(z)&=P(min(X_1,X_2,...,X_n)<=z)\
  &=1-P(min(X_1,X_2,..,X_n)>z)\
  &=1-(P(X_1>z,X_2>z,...,X_n>z))\
  &=1-product_(i=1)^n P(X_i>z)\
  &=1-(1-F_(X) (z))^n.
  $
]
#baitoan[
 Cho $X_1, dots, X_n$ độc lập cùng phân phối (independent identical distribution, i.i.d.) có trung bình $mu$ và phương sai $sigma^2$.

  Cho
  $
    overline(X) = 1/n sum_(j=1)^n X_j.
  $

  Tìm
  $
    E(overline(X)), quad "var"(overline(X)).
  $
]
#loigiai[

  Vì $X_1...X_n$ có cùng phân phối xác suất , nên kỳ vọng và phương sai của $X_i$ giống nhau, do đó
  $
  E(overline(X))=E(1/n sum_(j=1)^n X_j)=1/n n mu=mu
  $
  Hơn nữa, có $V a r(overline(X))=V a r(sum_(j=1)^n X_))=1/(n^2)=n 1/(n^2) sigma^2=1/n sigma^2$.
]
#baitoan[
Cho biến ngẫu nhiên $epsilon_1, dots, epsilon_n$ độc lập cùng phân phối với
  $
    E(epsilon_1) = a,
    quad "var"(epsilon_1) = sigma^2.
  $

  Tính theo $a$ và $sigma^2$ các biểu thức sau:

  (a)
  $
    E(epsilon_1 dots epsilon_n).
  $

  (b)
  $
    E(epsilon_1^2 dots epsilon_n^2).
  $

  (c)
  $
    E(sum_(j=1)^n j epsilon_j).
  $
]
#loigiai[

  *a)* Vì các biến ngẫu nhiên $epsilon_1,...,epsilon_n$ độc lập có cùng phân phối nên,
  $
  E(product_(i=1)^n epsilon_i)=product_(i=1)^n E(epsilon_i)=a...a=a^n
  $
  Hơn nữa, có $V a r (epsilon_i)=E(epsilon_i^2)-(E(epsilon_i))^2=sigma^2-a^2  $. Do đó,

  *b)* $
  E(product_(i=1)^n epsilon_i^2)=product_(i=1)^n E(epsilon_i^2)=product_(i=1)^n (sigma^2+a^2)=(sigma^2+a^2)^n
  $

  *c)* Theo tính tuyến tính của kỳ vọng,
  $
  E(sum_(j=1)^n j epsilon_j)=sum_(j=1)^n E(j epsilon_j)=sum_(j=1)^n j E(epsilon_j)=sum_(i=1)^n j a=a sum_(j=1)^n j=(a n(n+1))/2.
  $
]
#baitoan[
 Cho biến ngẫu nhiên $epsilon_1, dots, epsilon_n$ độc lập cùng phân phối với
  $
    E(epsilon_1) = 0.
  $

  Giả sử $f: [0,1] -> RR$ là hàm Lipschitz, nghĩa là tồn tại $K > 0$ sao cho
  $
    |f(x) - f(y)| <= K |x-y|.
  $

  Cho
  $
    Y_i = f(i/n) + epsilon_i,
    quad i = 1, dots, n.
  $

  Đặt
  $
    hat(sigma)_n
    = 1/(2(n-1)) sum_(i=1)^(n-1) (Y_(i+1)-Y_i)^2.
  $

  Chứng minh
  $
    lim_(n -> infinity) E(hat(sigma)_n)
    = "var"(epsilon_1),
  $

  $
    lim_(n -> infinity) "var"(hat(sigma)_n) = 0.
  $

  Từ đó suy ra
  $
    lim_(n -> infinity)
    E((hat(sigma)_n - "var"(epsilon_1))^2) = 0.
  $
]
#loigiai[

  
]
#pagebreak()
= Biến Ngẫu Nhiên Rời Rạc
Cho b.n.n $X$ xác định trên không gian xác suất $(Omega,cal(M),cal(P))$, hàm phân phối xác suất tích lũy của b.n.n $X$ là : $F_X (u)=P(X<=u), forall u in RR$. Đặt $D_x={"Tập các điểm không liên tục của Fx"}$. Ta phân tích được $F_X (u)=F(u)+G(u), forall u in RR$ trong đó :
- G là hàm không âm, không giảm liên tục trên $RR$.
- F là hàm bậc thang, có dạng $F(u)=sum_(x in D_x) P(X=x) I_([x,infinity))(u)$.

#dinhnghia[
  X gọi là b.n.n rời rạc khi và chỉ khi $G(u)=0,forall u in RR$, hay $F_X (u)=F(u),forall u in RR$.
]
Ta có : Miền giá trị $X(Omega)=D_x "hầu chắc chắn"$. Với $D_x={x_1,x_2,..,x_n,...}$ và hàm mật độ xác suất $f_X$ của b.n.n rời rạc $X$ được định nghĩa là :
$
f_X (x)=cases(P(X=x) &: "nếu" x in D_x,0 &: "nếu" x in.not D_x)

$
#vidu[
  X là số chấm xuất hiện khi tung xúc xắc $1$ lần.
  Ta có hàm phân phối xác suất tích lũy của X là :
  $
  F_X (u)= cases(0 &: u<1,1/6 &: 1<=u<2, 2/6 &: 2<=u<3, 3/6 &: 3<=u<4, 4/6 &: 4<=u<5 , 5/6 &: 5<=u<6, 1 &: u>=6)
  
  $
  Ta thấy $F_x$ là hàm bậc thang nên $G(u)=0,forall u in RR$. Khi đó, $D_X={1,2,3,4,5,6}$. Và $F_x (u)=F(u)=sum_(x in D_x) P(X=x) I_([x,infinity)) (u)$. Ta có miền giá trị
  $
  X(Omega)=D_x={"Tập tất cả các giá trị b.n.n X có thể nhận"}.
  $
  Hàm mật độ xác suất tương ứng :
  $
  f_x (x)=P(X=x) , "nếu" x in D_x
  $
  Với ví dụ trên, $f_x (2)=P(X=2)=1/6, f_x(2,5)=P(X=2,5)=0 "vì" 2,5 in.not D_x$.
]
== Phân phối xác suất của biến ngẫu nhiên rời rạc

Với $X$ là b.n.n rời rạc, phân phối xác suất tương ứng của $X$ là : Độ đo Stieltjes $lambda_X$ của b.n.n $X$, khi đó
$
lambda_X=lambda_x ^d + f_x dif x
$
thỏa $lambda_X (A)=lambda_x ^d (A)+integral_A f_x (x) dif x$ với $f_x=G'$ và $lambda_x ^d=sum_(x in D_x) P(X=x) times delta_x$. Khi đó,với $X$ là b.n.n rời rạc thì,
$
lambda_x (A)=lambda_x^d (A)=sum_(x in D_x) P(X=x) times delta_x (A)=P(X in A), forall A in cal(B(RR)).
$
#vidu[

  Với $X$ là số chấm khi tung $1$ xúc xắc $1$ lần. Ta có :
  $
  lambda_x (A)=lambda_x^d (A)=sum_(x in D_x) P(X=x) times delta_x (A)=P(X=1) times delta_1 (A)+P(X=2) times delta_2 (A)+... P(X=6) times delta_6 (A)
  $
  Tính xác suất $P(X>=3)$ , khi đó $A=[3,infinity)$ suy ra 
  $
  lambda_x (A)=1/6 +1/6 + 1/6+1/6=4/6
  $
]
== Kỳ vọng, Phương sai

X là b.n.n rời rạc
- Kỳ vọng : $
E(X)=sum_(x in D)x P(X=x)
$
Với hàm $h : RR-> RR$ liên tục, ta có
$
E(h(X))=sum_(x in D_x) h(x) P(X=x)
$
Áp dụng : $E(X^2)=sum_(x in D_x) x^2 P(X=x)$.
- Phương sai :
$
V a r (X)=E((X-E(X))^2)=sum_(x in D_X) (x-E(x))^2 P(X=x)=E(X^2) - (E(X))^2
$
- Moment bậc k của $X$, $k in NN$.
$
E(X^k)=sum_(x in D_x) x^k P(X=x)
$
- Hàm sinh moment của $X$.
$
M_x (t)= E(e^(t x))= sum_(x in D_X) e^(t x) P(X=x), forall t in RR
$
#vidu[

  X là số chấm khi tung $1$ xúc xắc $1$ lần, ta có $D_X={1,2,3,4,5,6}$.

  Kỳ vọng (Trung bình) của $X$ là :

  $
  E(X)&=sum_(x in D_x) x P(X=x)=1times 1/6 + 2 times 1/ +....=21/6\
  E(X^2)&=sum_(x in D_x) x^2 P(X=x)=1^2 1/6 + 2^2 .1/6=81/6 => V a r (X)=E(X^2)-(E(X))^2
  $
  Cách khác, $V a r(X)=sum_(x in D_x) (x-E(x)^)^2 p(X=x)$

  Hàm sinh moment của $X$ là :
  $
  M_x (t)=E(e^(t x))=sum_(x in D_x) e^(t x)P(X=x)
  =1/6 (e^t+e^(2 t)+...+ e^(6 t)), t in RR
  $
  
]
#menhde[

  $M_x (t)$ là hàm sinh moment của b.n.n X. Ta có $M_x ^(k)(0)=E(X^k)$, chẳng hạn $M'_x (0)=E(X)$.
]

#dinhly[

  Cho b.n.n $X$ có hàm sinh moment là $M_X$, b.n.n $Y$ có hàm sinh moment là $M_Y$.Nếu $M_X (t)=M_y (t)$, với $t$ thuộc một lân cận $U subset RR, 0 in U$, thì $X$ và $Y$ có cùng phan phối xác suất.
]
== Một số phân phối xác suất thông dụng
=== Phân phối Bernoulli

b.n.n rời rạc $X$ gọi là tuân theo phân phối Bernoulli, ký hiệu $X ~ $Bernoulli(p) với tham số $0<p<1$ nếu $X(Omega)=D_X ={0,1}$, với xác suất $P(X=1)=p$ và $P(X=0)=1-P(X=1)=1-p$.

Ta có: Kỳ vọng (Trung Bình) : $E(X)=p$, phương sai : $V a r (X)=p(1-p)$.
#vidu[

  Gọi $X$ là số lần xuất hiện mặt $6$ chấm khi tung $1$ xúc xắc $1$ lần, ta có :
  $
  D_X={0,1}, X=cases(1 &: "Mặt 6 chấm xuất hiên", 0 &: "Nếu mặt 6 chấm không xuất hiện")
  $
  $p=P(X=1)=1/6 => X~"Bernoulli (p)" "với" p=1/6$.
]
=== Phân phối nhị thức : $"bnom"(n,p)$.

Phân phối nhị thức $"bnom"(n,p)$ thì dùng để mô hình hóa hay đếm số phần bủ thỏa tính chất $A$ nào đó trong tổng số n phần. Ví dụ, trồng $n$ cây con độc lập, $X="số cây ra rễ trong số cây n ruộng cày"$.

$X="Số linh kiện bị lỗi trong 1 lô hàng"$.
#dinhnghia[

  b.n.n rời rạc $X$ được gọi là tuân theo phân phối nhị thức binom(n,p) nếu : $
  X(Omega)=D_x={0,1,2,..,n}
  $
  và phân phối xác suất :
  $
  P(X=k)=C_n^k times p^k times (1-p)^(n-k), "với k" in D_x={0,1,2,...,n}
  $
]
#vidu[

  Một loại cây con có tỷ lệ ra rễ là $80%$. Trồng $20$ cây độc lập.

  *a)* Tính xác suất có ít nhất $10$ cây ra rễ.

  *b)* Tính trung bình số cây ra rễ.

  Gọi $X$ là số cây ra rễ trong số $20$ cây được trồng.

  Ta có $X$ tuân theo phân phối nhị thức binom(n,p) với $n=20$ và $p= $ xác suất để $1$ cây ra rễ $=$ tỷ lệ cây ra rễ = $80%=0.8$.
]
#chungminh[
  
  *a)* Xác suất có ít nhất $10$ cây ra rễ là :
  $
  P(X>=10)=sum_(k=10)^n P(X=K)=sum_(k=10)^n C_n^k p^k (1-p)^(n-k)=..
  $
  $X(Omega)=D_X={0,1,2,...,n}$.

  *b)* Trung bình số cây ra rễ là :
  $
  E(X)=n p=20 times 0.8 =16 "cây"
  $

  === Phân phối Poisson

  Thường dùng để mô hình hóa / đếm số lần một biến cố $A$ nào đó xảy ra trong $1$ khoảng thời gian hoặc $1$ khu vực địa lý. Ví dụ : Đếm số khách hàng đến quán café trong ngày., đếm số sự cố xảy ra khi truyền tín hiệu ở khu vực dân cư.
#dinhnghia[
  B.n.n rời rạc $X$ gọi là tuân theo phân phối Poison, ký hiệu $X ~P o i s(lambda)$, với tham số $lambda>0$, nếu miền giá trị $X(Omega)=D_X={0,1,2,...}=NN$, và hàm mật độ xác suất.
  $
  f_X (k)=cases(e^(-lambda) lambda^k/k! &: quad "nếu" k in D_X=NN, 0 &: "nếu" k in.not D_x).
  $

  Ta có, $
  sum_(k in D_x) f_X (k)=sum_(k=0)^infinity f_x (k)=e^(-lambda) sum_(k=0)^(infinity) lambda^k /k!=e^(-lambda) e^(lambda)=1
  $

    
  ]
]
#menhde[
 Cho $X~P o i s(lambda_1)$ và $Y~P o i s(lambda_2)$. với $lambda_1.lambda_2 >0$. Nếu $X,Y$ độc lập thì $X+Y~ P o i s(lambda_1+lambda_2)$.
]
#vidu[

  X là số khách đến cửa hàng ở khu vực A trong $1$ ngày.

  Y là số khác đến cửa hàng ở khu vực $B$ trong $1$ ngày.

  Ta có $X+Y$ là số khác đến $2$ cửa hàng này trong $1$ ngày.

  Tại $1$ quầy thanh toán trong siêu thị có trung bình $8$ khách đến trong $1$ giờ. Giả sử số khách đến quầy thanh toán trong $1$ giờ tuân theo p.p Poison.

  Tính xác suất trong $1$ giờ.

  *a)* Có đúng $5$ khách đến\
  
  *b)* Có ít nhất $4$ khách đến.

  Gọi $X$ là số khách đến quầy thanh toán trong $1$ giờ. Ta có $X ~ P o i s(lambda),"với "lambda>0$.Trung bình số khách đến quầy trong $1$ giờ là : $E(X)=lambda=8 "khách"$.
  
  
  *a)* Xác suất có $5$ khách đến là :
  $
  P(X=5)=e^(-lambda) times lambda^5 / 5!=e^(-8) times 8^5/5!
  $

  *b)* Xác suất có ít nhất $4$ khách đến là :
  $
  P(X>=4)=sum_(k=4)^infinity P(X=k)=1-P(X<4)=1-sum_(k=0)^3 P(X=k)
  $

]



#dinhly[
Tính xấp xỉ phần phối nhị thức binom(n,p) bằng phân phối Poisson.
  Đối với p.p nhị thức binom(n,p) khi $n$ lớn. $C_n^k$ không tính được.
]

#chungminh[

  Cho dãy biến ngẫu nhiên $X_n ~ B(n,p_n)$ thỏa mãn
  $
    lim_(n -> infinity) n p_n = lambda > 0.
  $

  Ta cần chứng minh rằng với mọi $k in bb(N)_0$ cố định,
  $
    lim_(n -> infinity) P(X_n = k)
    = e^(-lambda) frac(lambda^k, k!).
  $

  Theo công thức phân phối nhị thức, với $n >= k$, ta có
  $
    P(X_n = k)
    &= binom(n,k) p_n^k (1-p_n)^(n-k) \
    &= frac(n!,k!(n-k)!) p_n^k (1-p_n)^(n-k) \
    &= frac((n p_n)^k,k!)
       product_(j=0)^(k-1) (1-frac(j,n))
       (1-p_n)^n (1-p_n)^(-k).
  $

  Ta lần lượt xét giới hạn của các nhân tử.

  *Thứ nhất.* Vì $n p_n -> lambda$ khi $n -> infinity$ nên
  $
    lim_(n -> infinity) frac((n p_n)^k,k!)
    = frac(lambda^k,k!).
  $

  *Thứ hai.* Vì $k$ cố định nên
  $
    lim_(n -> infinity)
    product_(j=0)^(k-1) (1-frac(j,n))
    = 1.
  $
  Với $k=0$, quy ước tích rỗng bằng $1$.

  *Thứ ba.* Từ giả thiết $n p_n -> lambda$, suy ra
  $p_n -> 0$. Ta có
  $
    ln((1-p_n)^n)
    &= n ln(1-p_n) \
    &= (n p_n) frac(ln(1-p_n),p_n).
  $

  Mặt khác,
  $
    lim_(t -> 0) frac(ln(1-t),t) = -1.
  $

  Do đó,
  $
    lim_(n -> infinity) n ln(1-p_n)
    = -lambda.
  $

  Sử dụng tính liên tục của hàm mũ, suy ra
  $
    lim_(n -> infinity) (1-p_n)^n
    = e^(-lambda).
  $

  *Thứ tư.* Vì $p_n -> 0$ và $k$ cố định nên
  $
    lim_(n -> infinity) (1-p_n)^(-k) = 1.
  $

  Kết hợp các giới hạn trên, ta thu được
  $
    lim_(n -> infinity) P(X_n = k)
    &= frac(lambda^k,k!) dot 1 dot e^(-lambda) dot 1 \
    &= e^(-lambda) frac(lambda^k,k!).
  $

  Vậy, với mọi $k in bb(N)_0$ cố định,
  $
    lim_(n -> infinity) P(X_n = k)
    = e^(-lambda) frac(lambda^k,k!).
  $

  Điều phải chứng minh.
]

#vidu[

  Tỷ lệ bưu phẩm bị thất lạc khi giao hàng là $2%$. Một lô gần $5000$ bưu phẩm cần được giao. Tính xác suất có không quá $15$ bưu phẩm bị thất lạc. 
]
#chungminh[

  Gọi $X$ là số bưu phẩm bị thất lạc khi giao tổng số $5000$ bưu phẩm. Ta có, $X~ "binom(n,p)"$ với $n=5000$ và $p=$ tỷ lệ bưu phẩm bị thất lạc = $0.2%$.

  Xác suất có không quá $15 b p$ bị thất lạc :
  $
  P(X<=15)=sum_(k=0)^15 P(X=k)=sum_(k=0)^15 C_n ^k p^k (1-p)^(n-k) ~ sum_(k=0)^15 e^(-lambda) lambda^k/k! "với "lambda=n times p=0.2% times 5000 =10
  $
]
#pagebreak()
== Bài Tập
=== Dạng 1. Tìm xác suất $P(a < X < b)$ nếu $X$ rời rạc

#ly-thuyet[
  Cho $X$ có hàm mật độ $f_X(x_i) = P(X = x_i)$, $i = 1, dots, n$, khi đó với các biến ngẫu nhiên rời rạc ta có

  $ P(a < X < b) = sum_(a < x_i < b) P(X = x_i) $

  $ P(X < b) = sum_(x_i < b) P(X = x_i) $

  $ P(X > a) = sum_(x_i > a) P(X = x_i) $
]

#baitoan[
  *Bài 1.* Số vết bắn trên các tấm gốm là một biến ngẫu nhiên có hàm xác suất

  $ p(k) = e^(-5) frac(5^k, k!) . $

  Tìm xác suất có:

  (a) Ít nhất $1$ vết bắn trên tấm gốm.

  (b) Nhiều nhất $7$ vết bắn trên tấm gốm.
]
#loigiai[

  *a)* Ta tính xác suất có ít nhất $1$ vết bắn trên tấm gốm nghĩa là, 
  $
  P(X>=1)=1-P(X<1)=1-P(X=0)=1-e^(-5) (5^0)/0! =1-e^(-5)=0.99
  $
  *b)* Xác suất nhiều nhất $7$ vết bắn trên tấm gốm là :
  $
  P(X<=7)=sum_(i=0)^7 P(X=i)=0.868
  $
]
=== Dạng 2. Tính $E(g(Y))$

#ly-thuyet[
  Trường hợp $Y$ rời rạc. Cho
  $Y(Omega) = brace.l y_i : i in J subset NN brace.r$,
  $g: RR -> RR$. Khi đó

  $ E(g(Y)) = sum_(i in J) g(y_i) P(Y = y_i). $

  Nếu $X ~ Y$ thì $g(X) ~ g(Y)$ và $E(g(X)) = E(g(Y))$.
]

#baitoan[
  *Bài 1.* Cho $Y(Omega) = brace.l y_i : i in J subset NN brace.r$,
  $g: RR -> RR$. Chứng minh

  $ E(g(Y)) = sum_(i in J) g(y_i) P(Y = y_i). $
]
#loigiai[
Giả sử $g(Y)$ khả tích, tức là $E(|g(Y)|) < infinity$.

Với mỗi $i in J$, đặt
$
  A_i = {omega in Omega : Y(omega) = y_i}.
$

Vì $Y$ là biến ngẫu nhiên nên $A_i in cal(M)$ với mọi $i in J$.

Hơn nữa, do các giá trị $y_i$ đôi một khác nhau nên các tập $A_i$ đôi một rời nhau và
$
  union_(i in J) A_i = Omega.
$

Với mọi $omega in Omega$, tồn tại duy nhất $i in J$ sao cho $Y(omega) = y_i$. Do đó,
$
  g(Y(omega))
  = sum_(i in J) g(y_i) I_(A_i)(omega).
$

*Trường hợp 1: $g(Y) >= 0$.*

Theo định nghĩa kỳ vọng, ta có
$
  E(g(Y))
  &= integral_Omega g(Y(omega)) dif P(omega) \
  &= integral_Omega
     sum_(i in J) g(y_i) I_(A_i)(omega)
     dif P(omega) \
  &= sum_(i in J) g(y_i)
     integral_Omega I_(A_i)(omega) dif P(omega) \
  &= sum_(i in J) g(y_i) P(A_i) \
  &= sum_(i in J) g(y_i) P(Y = y_i).
$

Trong đó, đẳng thức thứ ba được suy ra từ định lý hội tụ đơn điệu, vì các số hạng đều không âm.

*Trường hợp 2: $g(Y)$ có thể nhận giá trị âm.*

Ta phân tích
$
  g(Y) = g(Y)^+ - g(Y)^-,
$
trong đó
$
  g(Y)^+ = max{g(Y), 0},
$
$
  g(Y)^- = max{-g(Y), 0}.
$

Vì $g(Y)$ khả tích nên cả $g(Y)^+$ và $g(Y)^-$ đều có kỳ vọng hữu hạn.

Áp dụng kết quả của trường hợp 1 cho hai hàm không âm trên, ta được
$
  E(g(Y))
  &= E(g(Y)^+) - E(g(Y)^-) \
  &= sum_(i in J) g(y_i)^+ P(Y = y_i)
     - sum_(i in J) g(y_i)^- P(Y = y_i) \
  &= sum_(i in J)
     (g(y_i)^+ - g(y_i)^-) P(Y = y_i) \
  &= sum_(i in J) g(y_i) P(Y = y_i).
$


]
#pagebreak()
#baitoan[
  *Bài 2.* Tìm $E((X + 1)^2)$ của các biến ngẫu nhiên sau:

  (a)
#align(center)[
  #table(
    columns: 3, align: center, inset: (x: 14pt, y: 3pt), stroke: none,
    table.hline(y: 1), table.vline(x: 1),
    [$X$], [$-1$], [$1$],
    [$P$], [$0.4$], [$0.6$],
  )
]
  (b)
#align(center)[
  #table(
    columns: 4, align: center, inset: (x: 14pt, y: 3pt), stroke: none,
    table.hline(y: 1), table.vline(x: 1),
    [$X$], [$0.05$], [$0.06$], [$0.04$],
    [$P$], [$0.3$], [$0.4$], [$0.3$],
  )
]
  (c)
#align(center)[
  #table(
    columns: 4, align: center, inset: (x: 14pt, y: 3pt), stroke: none,
    table.hline(y: 1), table.vline(x: 1),
    [$X$], [$2$], [$0$], [$-2$],
    [$P$], [$0.2$], [$0.4$], [$0.4$],
  )
]
  (d) Bernoulli$(p)$: $X: Omega -> brace.l 0, 1 brace.r$, với

  $ f_X(1) = P(X = 1) = p, quad f_X(0) = P(X = 0) = 1 - p. $

  (e) Nhị thức $"Binom"(n,p)$:

  $ f_X(k) = P(X = k) = C_n^k p^k (1 - p)^(n-k), quad k = 0,1, dots, n. $

  Chọn $n = 3$, $p = 0.4$.
]
#loigiai[

  
Ta sử dụng công thức kỳ vọng của hàm theo biến ngẫu nhiên rời rạc:
$
  E(g(X)) = sum_i g(x_i) P(X=x_i).
$

Đặc biệt, với $g(x)=(x+1)^2$, ta có
$
  E((X+1)^2)
  = sum_i (x_i+1)^2 P(X=x_i).
$

Mặt khác, theo tính tuyến tính của kỳ vọng,
$
  E((X+1)^2)
  &= E(X^2+2X+1) \
  &= E(X^2)+2E(X)+1.
$

Từ công thức phương sai,
$
  "Var"(X)=E(X^2)-E(X)^2,
$
suy ra
$
  E((X+1)^2)
  = "Var"(X)+(E(X)+1)^2.
$

*(a) Trường hợp $X in {-1,1}$.*

_Cách 1. Sử dụng trực tiếp định nghĩa kỳ vọng._

Ta có
$
  E((X+1)^2)
  &= (-1+1)^2 P(X=-1)
     +(1+1)^2 P(X=1) \
  &= 0^2 dot 0.4 + 2^2 dot 0.6 \
  &= 2.4.
$

_Cách 2. Khai triển và tính các moment._

Ta tính
$
  E(X)
  &= (-1) dot 0.4 + 1 dot 0.6 \
  &= 0.2,
$
và
$
  E(X^2)
  &= (-1)^2 dot 0.4 + 1^2 dot 0.6 \
  &= 1.
$

Do đó,
$
  E((X+1)^2)
  &= E(X^2)+2E(X)+1 \
  &= 1+2 dot 0.2+1 \
  &= 2.4.
$

_Cách 3. Tìm phân phối của $Z=(X+1)^2$._

Đặt $Z=(X+1)^2$. Khi đó
$
  Z = cases(
    0 & "nếu " X=-1,
    4 & "nếu " X=1.
  )
$

Suy ra
$
  P(Z=0)=0.4, quad P(Z=4)=0.6.
$

Theo định nghĩa kỳ vọng,
$
  E(Z)
  &= 0 dot 0.4+4 dot 0.6 \
  &= 2.4.
$

Vậy


*(b) Trường hợp $X in {0.05,0.06,0.04}$.*

_Cách 1. Tính trực tiếp theo phân phối._

Ta có
$
  E((X+1)^2)
  &= (1.05)^2 dot 0.3
     +(1.06)^2 dot 0.4
     +(1.04)^2 dot 0.3 \
  &= 0.33075+0.44944+0.32448 \
  &= 1.10467.
$

_Cách 2. Sử dụng tính tuyến tính của kỳ vọng._

Trước hết, ta tính
$
  E(X)
  &= 0.05 dot 0.3
     +0.06 dot 0.4
     +0.04 dot 0.3 \
  &= 0.051.
$

Tương tự,
$
  E(X^2)
  &= 0.05^2 dot 0.3
     +0.06^2 dot 0.4
     +0.04^2 dot 0.3 \
  &= 0.00267.
$

Do đó,
$
  E((X+1)^2)
  &= E(X^2)+2E(X)+1 \
  &= 0.00267+2 dot 0.051+1 \
  &= 1.10467.
$



*(c) Trường hợp $X in {2,0,-2}$.*

_Cách 1. Sử dụng trực tiếp định nghĩa._

Ta có
$
  E((X+1)^2)
  &= (2+1)^2 dot 0.2
     +(0+1)^2 dot 0.4
     +(-2+1)^2 dot 0.4 \
  &= 9 dot 0.2+1 dot 0.4+1 dot 0.4 \
  &= 2.6.
$

_Cách 2. Sử dụng công thức moment._

Ta tính
$
  E(X)
  &= 2 dot 0.2+0 dot 0.4+(-2) dot 0.4 \
  &= -0.4.
$

Mặt khác,
$
  E(X^2)
  &= 2^2 dot 0.2+0^2 dot 0.4+(-2)^2 dot 0.4 \
  &= 2.4.
$

Do đó,
$
  E((X+1)^2)
  &= E(X^2)+2E(X)+1 \
  &= 2.4+2(-0.4)+1 \
  &= 2.6.
$



*(d) Trường hợp $X$ có phân phối Bernoulli $(p)$.*

_Cách 1. Tính trực tiếp theo phân phối._

Theo giả thiết,
$
  P(X=1)=p, quad P(X=0)=1-p.
$

Do đó,
$
  E((X+1)^2)
  &= (0+1)^2 P(X=0)
     +(1+1)^2 P(X=1) \
  &= 1 dot (1-p)+4p \
  &= 1+3p.
$

_Cách 2. Khai thác tính chất của biến Bernoulli._

Vì $X in {0,1}$ nên
$
  X^2=X.
$

Suy ra
$
  E((X+1)^2)
  &= E(X^2+2X+1) \
  &= E(X)+2E(X)+1 \
  &= 3E(X)+1 \
  &= 1+3p.
$

_Cách 3. Sử dụng công thức phương sai._

Ta biết
$
  E(X)=p,
  quad "Var"(X)=p(1-p).
$

Do đó,
$
  E((X+1)^2)
  &= "Var"(X)+(E(X)+1)^2 \
  &= p(1-p)+(p+1)^2 \
  &= 1+3p.
$



*(e) Trường hợp $X$ có phân phối nhị thức $B i n o m(3,0.4)$.*

Theo định nghĩa,
$
  P(X=k)
  = binom(3,k) (0.4)^k (0.6)^(3-k),
$
với $k=0,1,2,3$.

_Cách 1. Tính trực tiếp từ phân phối._

Ta có
$
  P(X=0)&=0.216, \
  P(X=1)&=0.432, \
  P(X=2)&=0.288, \
  P(X=3)&=0.064.
$

Theo công thức kỳ vọng,
$
  E((X+1)^2)
  &= sum_(k=0)^3 (k+1)^2 P(X=k) \
  &= 1 dot 0.216+4 dot 0.432
     +9 dot 0.288+16 dot 0.064 \
  &= 5.56.
$

_Cách 2. Sử dụng kỳ vọng và phương sai._

Với $X$ có phân phối $B i n o m(n,p)$, ta có
$
  E(X)=n p,
  quad "Var"(X)=n p(1-p).
$

Trong trường hợp này,
$
  E(X)=3 dot 0.4=1.2,
$
và
$
  "Var"(X)=3 dot 0.4 dot 0.6=0.72.
$

Do đó,
$
  E((X+1)^2)
  &= "Var"(X)+(E(X)+1)^2 \
  &= 0.72+(1.2+1)^2 \
  &= 5.56.
$

_Cách 3. Biểu diễn thành tổng các biến Bernoulli độc lập._

Ta có thể biểu diễn
$
  X=X_1+X_2+X_3,
$
trong đó $X_1,X_2,X_3$ độc lập và cùng có phân phối Bernoulli $(0.4)$.

Khi đó,
$
  X^2
  &= (X_1+X_2+X_3)^2 \
  &= X_1^2+X_2^2+X_3^2
     +2X_1 X_2+2X_1 X_3+2X_2 X_3.
$

Vì $X_i in {0,1}$ nên
$
  X_i^2=X_i.
$

Do tính độc lập, với $i != j$, ta có
$
  E(X_i X_j)
  &= E(X_i)E(X_j) \
  &= (0.4)^2.
$

Suy ra
$
  E(X^2)
  &= 3 dot 0.4+2 dot 3 dot (0.4)^2 \
  &= 2.16.
$

Mặt khác,
$
  E(X)=3 dot 0.4=1.2.
$

Do đó,
$
  E((X+1)^2)
  &= E(X^2)+2E(X)+1 \
  &= 2.16+2 dot 1.2+1 \
  &= 5.56.
$
]





#baitoan[
  Cho $Y$ có phân phối nhị thức $B i n o m(2,0.1)$.
  Tính $E(Y^2)$.
]
#loigiai[

_Cách 1. Sử dụng trực tiếp định nghĩa kỳ vọng._

Theo giả thiết,
$
  P(Y=k)
  = binom(2,k) (0.1)^k (0.9)^(2-k),
$
với $k=0,1,2$.

Ta tính
$
  P(Y=0)&=0.81, \
  P(Y=1)&=0.18, \
  P(Y=2)&=0.01.
$

Theo định nghĩa kỳ vọng,
$
  E(Y^2)
  &= sum_(k=0)^2 k^2 P(Y=k) \
  &= 0^2 dot 0.81
     +1^2 dot 0.18
     +2^2 dot 0.01 \
  &= 0.22.
$

_Cách 2. Sử dụng công thức phương sai._

Vì $Y$ có phân phối $B i n o m(2,0.1)$ nên
$
  E(Y)=2 dot 0.1=0.2,
$
và
$
  "Var"(Y)=2 dot 0.1 dot 0.9=0.18.
$

Từ công thức
$
  "Var"(Y)=E(Y^2)-E(Y)^2,
$
suy ra
$
  E(Y^2)
  &= "Var"(Y)+E(Y)^2 \
  &= 0.18+(0.2)^2 \
  &= 0.22.
$

_Cách 3. Biểu diễn thành tổng các biến Bernoulli độc lập._

Ta viết
$
  Y=Y_1+Y_2,
$
trong đó $Y_1,Y_2$ độc lập và cùng có phân phối Bernoulli $(0.1)$.

Theo tính tuyến tính của kỳ vọng,
$
  E(Y^2)
  &= E((Y_1+Y_2)^2) \
  &= E(Y_1^2)+2E(Y_1 Y_2)+E(Y_2^2).
$

Vì $Y_i in {0,1}$ nên
$
  Y_i^2=Y_i.
$

Do đó,
$
  E(Y_i^2)=E(Y_i)=0.1.
$

Mặt khác, vì $Y_1,Y_2$ độc lập,
$
  E(Y_1 Y_2)
  &= E(Y_1)E(Y_2) \
  &= (0.1)^2=0.01.
$

Suy ra
$
  E(Y^2)
  &= 0.1+2 dot 0.01+0.1 \
  &= 0.22.
$
]


#baitoan[


  Cho $Y$ có phân phối Poisson $(lambda)$, với $lambda>0$.

  Tính $E(Y)$ và $E(Y^2)$.
]

#loigiai[

_Cách 1. Sử dụng trực tiếp định nghĩa kỳ vọng._

Theo định nghĩa phân phối Poisson, ta có
$
  P(Y=k)
  = e^(-lambda) frac(lambda^k, k!),
$
với $k=0,1,2,dots$.

*Bước 1. Tính $E(Y)$.*

Theo định nghĩa kỳ vọng của biến ngẫu nhiên rời rạc,
$
  E(Y)
  &= sum_(k=0)^infinity k P(Y=k) \
  &= sum_(k=1)^infinity
     k e^(-lambda) frac(lambda^k,k!) \
  &= e^(-lambda)
     sum_(k=1)^infinity frac(lambda^k,(k-1)!) \
  &= lambda e^(-lambda)
     sum_(k=1)^infinity frac(lambda^(k-1),(k-1)!).
$

Đặt $j=k-1$, ta được
$
  E(Y)
  &= lambda e^(-lambda)
     sum_(j=0)^infinity frac(lambda^j,j!) \
  &= lambda e^(-lambda) e^lambda \
  &= lambda.
$



*Bước 2. Tính $E(Y^2)$.*

Nhận thấy rằng
$
  k^2=k(k-1)+k.
$

Do đó,
$
  E(Y^2)
  &= sum_(k=0)^infinity k^2 P(Y=k) \
  &= sum_(k=0)^infinity k(k-1)P(Y=k)
     +sum_(k=0)^infinity k P(Y=k) \
  &= E(Y(Y-1))+E(Y).
$

Ta tính riêng
$
  E(Y(Y-1))
  &= sum_(k=0)^infinity k(k-1)P(Y=k) \
  &= sum_(k=2)^infinity
     k(k-1)e^(-lambda) frac(lambda^k,k!) \
  &= e^(-lambda)
     sum_(k=2)^infinity frac(lambda^k,(k-2)!) \
  &= lambda^2 e^(-lambda)
     sum_(k=2)^infinity frac(lambda^(k-2),(k-2)!).
$

Đặt $j=k-2$, ta được
$
  E(Y(Y-1))
  &= lambda^2 e^(-lambda)
     sum_(j=0)^infinity frac(lambda^j,j!) \
  &= lambda^2 e^(-lambda)e^lambda \
  &= lambda^2.
$

Suy ra
$
  E(Y^2)
  &= E(Y(Y-1))+E(Y) \
  &= lambda^2+lambda.
$



_Cách 2. Sử dụng kỳ vọng và phương sai của phân phối Poisson._

Ta biết rằng nếu $Y$ có phân phối Poisson $(lambda)$ thì
$
  E(Y)=lambda,
  quad "Var"(Y)=lambda.
$

Mặt khác,
$
  "Var"(Y)=E(Y^2)-E(Y)^2.
$

Suy ra
$
  E(Y^2)
  &= "Var"(Y)+E(Y)^2 \
  &= lambda+lambda^2.
$



_Cách 3. Sử dụng hàm sinh xác suất._

Ta định nghĩa hàm sinh xác suất (Probability Generating Function) của $Y$ bởi
$
  G_Y(s)=E(s^Y)
  =sum_(k=0)^infinity s^k P(Y=k).
$

Vì $Y$ có phân phối Poisson $(lambda)$ nên
$
  G_Y(s)
  &= sum_(k=0)^infinity
     s^k e^(-lambda) frac(lambda^k,k!) \
  &= e^(-lambda)
     sum_(k=0)^infinity frac((lambda s)^k,k!) \
  &= e^(-lambda)e^(lambda s) \
  &= e^(lambda(s-1)).
$

Lấy đạo hàm theo $s$, ta có
$
  G_Y'(s)=lambda e^(lambda(s-1)).
$

Mặt khác,
$
  G_Y'(1)=E(Y).
$

Suy ra
$
  E(Y)
  &= G_Y'(1) \
  &= lambda.
$

Tiếp tục lấy đạo hàm lần hai,
$
  G_Y''(s)=lambda^2 e^(lambda(s-1)).
$

Do
$
  G_Y''(1)=E(Y(Y-1)),
$
nên
$
  E(Y(Y-1))
  &= G_Y''(1) \
  &= lambda^2.
$

Từ đẳng thức
$
  Y^2=Y(Y-1)+Y,
$
suy ra
$
  E(Y^2)
  &= E(Y(Y-1))+E(Y) \
  &= lambda^2+lambda.
$
]


*Nhận xét và mở rộng*

*1. Kỳ vọng của hàm theo biến ngẫu nhiên rời rạc.*

Nếu $X$ là biến ngẫu nhiên rời rạc nhận các giá trị $x_i$ thì
$
  E(g(X))=sum_i g(x_i)P(X=x_i),
$
với điều kiện kỳ vọng tồn tại.

*2. Moment của biến ngẫu nhiên.*

Moment bậc $r$ của $X$ được định nghĩa bởi
$
  m_r=E(X^r),
$
nếu kỳ vọng tồn tại.

Đặc biệt,
$
  m_1=E(X), quad m_2=E(X^2).
$

Ta có mối liên hệ
$
  "Var"(X)=m_2-m_1^2.
$

*3. Moment giai thừa của phân phối Poisson.*

Với $Y$ có phân phối Poisson $(lambda)$ và $r in bb(N)^+$, ta có công thức
$
  E(Y(Y-1) dots (Y-r+1))=lambda^r.
$

Thật vậy,
$
  &E(Y(Y-1) dots (Y-r+1)) \
  &= sum_(k=r)^infinity
     k(k-1) dots (k-r+1) P(Y=k) \
  &= e^(-lambda)
     sum_(k=r)^infinity frac(lambda^k,(k-r)!) \
  &= lambda^r e^(-lambda)
     sum_(j=0)^infinity frac(lambda^j,j!) \
  &= lambda^r.
$

Đây là công thức tổng quát để tính các moment giai thừa của phân phối Poisson.




=== Dạng 3. Tìm hàm sinh moment của biến ngẫu nhiên

#ly-thuyet[
  Cho $X(Omega) = brace.l x_1, dots, x_n brace.r$, $g: RR -> RR$.

  $ M_X(t) = E(e^(t X)) = sum_(j=1)^n e^(x_j t) P(X = x_j). $

  *Định lý.* Hai biến ngẫu nhiên $X$, $Y$ có cùng phân phối nếu $D_X = D_Y$ và $P(X = x) = P(Y = x)$ với mọi $x in D_X$.

  *Định lý.* Hai biến ngẫu nhiên $X$, $Y$ có cùng phân phối nếu $M_X(t) = M_Y(t)$ với $t$ thuộc một khoảng mở chứa $0$.
]

#baitoan[
  *Bài 1.* Giả sử $X,Y: Omega -> RR$ có

  $ D_X = brace.l x_1, x_2, dots brace.r, quad D_Y = brace.l y_1, y_2, dots brace.r $

  với $x_1 < x_2 < dots$ và $y_1 < y_2 < dots$.

  Chứng minh rằng nếu $M_X (t) = M_Y (t)$ trong một lân cận của $0$ thì $x_i = y_i$ với mọi $i$ và $P(X = x_i) = P(Y = x_i)$. Nghĩa là $X ~ Y$.
]
#loigiai[

  
]
#baitoan[
  *Bài 2.* Tìm hàm sinh moment của các biến ngẫu nhiên sau:

  (a) Bernoulli$(p)$: $X: Omega -> brace.l 0,1 brace.r$ với

  $ f_X(1) = P(X = 1) = p, quad f_X(0) = P(X = 0) = 1 - p. $

  (b) Nhị thức $"Binom"(n,p)$:

  $ f_X(k) = P(X = k) = C_n^k p^k (1-p)^(n-k), quad k = 0,1, dots, n. $

  (c) $"Pois"(lambda)$:

  $ f_X(k) = P(X = k) = e^(-lambda) frac(lambda^k, k!). $

  (d) $"Geom"(p)$:

  $ f_X(k) = (1-p)^k p, quad k = 0,1, dots. $
]

#baitoan[
  *Bài 3.* Cho biết $M_X(t)$, tìm kỳ vọng, phương sai của biến ngẫu nhiên $X$ nếu

  (a) $M_X (t) = m e^t + 2/3$.

  (b) $M_X (t) = (m e^t + 1/4)^40$, $m > 0$.
]
#loigiai[

  Với hàm sinh moment, ta có $E(X)=M'_X (0)$ và $E(X^2)=M''_X (0)$. Mặt khác, từ
  $
  M_X (t)=E(e^(t X)) quad "Với t=0, ta được" M_X (0)=E(1)=1
  $
  Do đó,
  
  *a)* Với $M_X (t)=m e ^t + 2/3$, thì
  $
  E(X)=M'_X (0)=m e ^0=m
  $
  Mà, $M_X (0)=E(1)=1 =>m +2/3=1 => m=1/3$. Do đó, $M'_X (t)=1/3=E(X)$. Tiếp tục, ta có $
  E(X^2)=M''_X (0)=m e ^0 =1/3 
  $
  Do đó, $V a r(X)=E(X^2)-(E(X))^2=1/3 -(1/3)^2=2/9$.

  *b)*
  Luôn có, $M_X (0)=1 => (m+1/4)^40 =1 >= m=3/4$, vì $m>0$.

  Lại có, $
  
  E(X)=M'_X (0)=40(m e^t+1/4)^39 m e^t=40.3/4=30
  
  $
  Tương tự, ta có
  $
  E(X^2)=M''_X (0)=907.5
  $
  Do đó, $V a r (X)=E(X^2)-(E(X))^2=15/2$.
  
  
]
#baitoan[
  *Bài 4.* Cho $X: Omega -> RR$, $a > 0$, $t in RR$. Tìm

  $ E(e^(t (X - E(X))/a)) $

  nếu

  (a) $X = 1$ với xác suất là $1/2$, $X = 0$ với xác suất là $1/2$.

  (b) $X = 1$ với xác suất là $1/2$, $X = -1$ với xác suất là $1/2$.

  (c) $X ~ "Pois"(lambda)$, $lambda > 0$.
]

#baitoan[
  *Bài 5.* Cho $X_1, dots, X_n: Omega -> RR$ là các biến ngẫu nhiên. Tính

  $ M_(X_1)(t) dots M_(X_n)(t) $

  biết

  (a) $X_i ~ "B"(n_i,p)$, $0 < p < 1$, $n_i in NN$.

  (b) $X_i ~ "Pois"(lambda_i)$, $lambda_i > 0$.
]

=== Dạng 4. Tìm kỳ vọng, phương sai biến ngẫu nhiên rời rạc

#ly-thuyet[
  Cho $X(Omega) = brace.l x_1, dots, x_n brace.r$, $g: RR -> RR$, có thể dùng công thức

  $ E(X^n) = (frac(d^n M_X, d t^n))_(t=0) $

  hay dùng công thức Lazy-Statistician:

  $ E(X) = sum_(j=1)^n x_j P(X = x_j) $

  $ E(X^2) = sum_(j=1)^n x_j^2 P(X = x_j) $

  $ "Var"(X) = E(X^2) - (E(X))^2. $
]

#baitoan[
  *Bài 1.* Tìm hàm sinh moment của biến ngẫu nhiên $X$, từ đó suy ra kỳ vọng, phương sai của $X$, nếu
#align(center)[
  #table(
    columns: 3, align: center, inset: (x: 15pt, y: 3pt), stroke: none,
    table.hline(y: 1), table.vline(x: 1),
    [$X$], [$3$], [$1$],
    [$P$], [$0.4$], [$0.6$],
  )
]
]
#baitoan[
  *Bài 2.* Tương tự Bài 1 với
#align(center)[
  #table(
    columns: 4, align: center, inset: (x: 15pt, y: 3pt), stroke: none,
    table.hline(y: 1), table.vline(x: 1),
    [$X$], [$0.05$], [$0.06$], [$0.1$],
    [$P$], [$0.3$], [$0.4$], [$0.3$],
  )
]
]
#baitoan[
  *Bài 3.* Tương tự Bài 1 với
#align(center)[
  #table(
    columns: 4, align: center, inset: (x: 15pt, y: 3pt), stroke: none,
    table.hline(y: 1), table.vline(x: 1),
    [$X$], [$2$], [$0$], [$-2$],
    [$P$], [$0.2$], [$0.4$], [$0.4$],
  )
]
]
#baitoan[
  *Bài 4.* Tìm kỳ vọng, phương sai của các biến ngẫu nhiên rời rạc có phân phối:

  (a) Bernoulli$(p)$: $X: Omega -> brace.l 0,1 brace.r$ với

  $ f_X(1) = P(X = 1) = p, quad f_X(0) = P(X = 0) = 1-p. $

  (b) Nhị thức $"Binom"(n,p)$:

  $ f_X(k) = P(X = k) = C_n^k p^k (1-p)^(n-k), quad k = 0,1, dots, n. $

  (c) Hình học $"Geom"(p)$:

  $ f_X(k) = P(X = k) = p (1-p)^k, quad k = 0,1,2, dots quad (0 < p < 1). $

  (d) $"Pois"(lambda)$:

  $ f_X(k) = P(X = k) = e^(-lambda) frac(lambda^k, k!). $
]

#baitoan[
  *Bài 5.* Cho $X_1, dots, X_n$ độc lập, có cùng phân phối với $X_1$ cho biết. Tính

  $ lim_(n -> infinity) E( e^(t (X_1-E(X_1))/sqrt(n)) dots e^(t (X_n-E(X_n))/sqrt(n)) ). $

  Cho biết:

  (a) $X_1 = 1$ với xác suất là $1/2$, $X_1 = 0$ với xác suất là $1/2$.

  (b) $X_1 = 1$ với xác suất là $1/2$, $X_1 = -1$ với xác suất là $1/2$.

  (c) $X_1 ~ "Pois"(lambda)$, $lambda > 0$.
]

#baitoan[
  *Bài 6.* Cho $X_1, dots, X_n$ độc lập, có cùng phân phối với $X_1$ cho biết. Tính

  $ lim_(n -> infinity) E[ e^(t (X_1-E(X_1))/sqrt(n "Var"(X_1))) dots e^(t (X_n-E(X_n))/sqrt(n "Var"(X_n))) ]. $

  Cho biết:

  (a) $X_1 = 2$ với xác suất là $1/2$, $X_1 = 0$ với xác suất là $1/2$.

  (b) $X_1 = 2$ với xác suất là $1/2$, $X_1 = -2$ với xác suất là $1/2$.

  (c) $X_1 ~ "Pois"(lambda)$, $lambda > 0$.
]

=== Dạng 5. Tìm phân phối bằng hàm sinh moment

#ly-thuyet[
  - Để tìm phân phối của $X$, ta tìm một biến ngẫu nhiên $Y$ sao cho $M_X(t) = M_Y(t)$. Khi đó $X ~ Y$.

  - Để tìm phân phối của tổng $X + Y$, ta có thể làm theo các bước sau:

  Bước 1: Ta tìm $M_X(t)$, $M_Y(t)$.

  Bước 2: Tìm $M_(X+Y)(t)$ bằng cách sử dụng $M_(X+Y)(t) = M_X(t) M_Y(t)$ với $X$, $Y$ độc lập.

  Bước 3: Từ $M_(X+Y)$ xác định phân phối có hàm sinh moment này.
]

#baitoan[
  *Bài 1.* Tìm biến ngẫu nhiên $X$ có hàm sinh moment là

  (a) $M_X(t) = 0.2 e^(3t) + 0.5 e^(-t) + m$, suy ra $P(X <= 2)$.

  (b) $M_X(t) = 0.1 e^(3t) + 0.4 e^(4t) + b e^(6t)$, suy ra $P(X <= 5)$.

  (c) $M_X(t) = m e^(2t) + n e^t$ biết $E(X) = 4/3$.
]

#baitoan[
  *Bài 2.* Cho biết $M_X(t)$, tìm phân phối của $X$ nếu

  (a) $M_X(t) = e^t/3 + 2/3$. Suy ra $P(X <= 1/2)$, $E(X)$.

  (b) $M_X(t) = e^(2t)/4 + m$. Suy ra $P(X <= 1)$, $E((X - 1)^2)$.

  (c) $M_X(t) = (3 e^t/4 + 1/4)^40$.

  Suy ra $P(X >= 3)$, $E((2 X - 3)^2)$.
]

#baitoan[
  *Bài 3.* Cho $X$, $Y$ độc lập. Chứng minh rằng:

  (a) Nếu $X ~ "Binom"(n,p)$, $Y ~ "Binom"(m,p)$ thì

  $ X + Y ~ "Binom"(n+m,p). $

  (b) Nếu $X ~ "Pois"(lambda)$, $Y ~ "Pois"(mu)$ thì

  $ X + Y ~ "Pois"(lambda+mu). $
]

#baitoan[
  *Bài 4.* Cho $X_1, dots, X_n$ độc lập cùng phân phối. Tìm hàm mật độ của

  $ S = sum_(j=1)^n X_j. $

  Suy ra $E(overline(X))$, $"Var"(overline(X))$ với $overline(X) = 1/n S$.

  Cho biết:

  (a) $X_1 ~ "Binom"(1,p)$.

  (b) $X_1 ~ "Pois"(lambda)$.
]

#pagebreak()
= Đề Thi Giữa Kỳ
== 2025-2026

#cau[
  *Câu 1. (5 điểm)*

  Một công ty có tỉ lệ khách hàng không hoàn thành trả nợ là $p$. Với khách hàng không hoàn thành trả nợ, công ty phát hiện tỉ lệ khách hàng có rủi ro tín dụng thấp là $t_n$, rủi ro vừa là $v_n$, rủi ro cao là $c_n$. Với khách hàng hoàn thành trả nợ, công ty thống kê được tỉ lệ khách hàng có rủi ro tín dụng thấp là $t_k$, rủi ro vừa là $v_k$, rủi ro cao là $c_k$.

  (a) (2đ) Tìm các điều kiện có thể có của các tỉ lệ này.

  (b) (2đ) Cho biết $v_n = 0.4$, $c_n = 0.3$, $v_k = 0.4$, $c_k = 0.4$. Tìm hàm $f(p)$ để xác suất khách hàng có tín dụng thấp là $f(p)$. Vẽ đồ thị hàm số $f(p)$.

  (c) (1đ) Với các giả thiết của câu (b), viết công thức tính xác suất để một khách hàng rủi ro tín dụng thấp hoàn thành việc trả nợ.
]

#cau[
  *Câu 2. (5 điểm)*

  Cho không gian xác suất $(Omega, cal(M), bb(P))$. Cho $A subset.eq Omega$, xét hàm

  $ X(omega) = cases(
    1 & quad omega in A,
    -1 & quad omega in Omega backslash A.
  ) $

  (a) (2đ) Với điều kiện nào của $A$ thì $X$ là một biến ngẫu nhiên trên $cal(M)$. Chứng minh điều đó.

  (b) (2đ) Cho thêm thông tin gì của $A$ thì có thể viết hàm phân phối tích lũy $F_X$ và độ đo phân phối của $X$. Viết các biểu thức đó ra.

  (c) (1đ) Sử dụng thông tin câu (b), hãy tính $E X$. Tìm max và min có thể có của $E X$.
]

#v(1em)
#line(length: 100%, stroke: 0.8pt)
#v(0.8em)

#align(center)[
  #text(size: 10pt, weight: "bold")[
    _HƯỚNG DẪN GIẢI_
  ]
]
#loigiai[
  
  *Câu 1)* Đặt $A$ là biến cố khách hàng không hoàn thành trả nợ. B,C,D lần lượt là biến cố khách hàng có rủi ro tín dụng lần lượt là thấp, vừa ,cao. Khi đó, từ giả thiết, ta có
  $
  P(A)=p => P(A^c)&=1-p\
  P(B | A)=t_n , P(C |A)&= v_n ,P(D|A)= c_n\
  P(B |A^c)=t_k , P(C | A^c)&=v_k, P( D | A^c)=c_k
  $

*a)*
Suy ra,
$
c_n+v_n+t_n&=1\ c_k+v_k+t_k&=1\ 0<p <1\ 0<=c_n,v_n,t_n,c_k,v_k,t_k&<=1
$
*b)* Từ $v_n=0.4$ và $c_n=0.3$ suy ra, $t_n=0.3$ và $t_k=0.2$. Do đó, $f(p)=P( B | A) P(A) + P( B | A^c) P(A^c)=p 0.3 +(1-p).0.2=0.1p+0.2$.

*c)* Áp dụng công thức Bayes, ta có xác suất
$
P( A^c | B)= (P( B| A^c)P(A^c))/(P(B))=(0.2(1-p))/(0.1p+0.2) =(-0.2 p+0.2) /(0.1p+0.2)
$
]

#loigiai[

  *Câu 2)*  Để $X$ là một b.n.n trên $cal(M)$, thì ta cần $A in cal(M)$. Thật vậy, ta kiểm tra điều kiện $
  X "là b.n.n" <=> A in cal(M)
  $
  *=>)* Giả sử $X$ là biến ngẫu nhiên, khi đó với bất kỳ $t in RR$
  $
  E_t={omega in Omega : X(omega)<=t} in cal(M)
  $
  Vì điều kiện trên đúng với bất kỳ $t in RR$, nên do đó, xét $t=-1$, thì $E_t=A^c$ mà $E_t in cal(M)$, nên $A^c in cal(M) => A in cal(M)$.

  *<=)* Giả sử $A in cal(M)$, ta chứng minh $X$ là b.n.n. Khi đó, cho trước $t in RR$, ta chứng minh
  $
  E_t={omega in Omega : X(omega)<=t} in cal(M)
  $
  Thật vậy, với $t in RR$ cho trước.

  Nếu $t< -1 => E_t=emptyset$.

  Nếu $-1<=t<1 => E_t=A^c$.

  Nếu $t>=1 => E_t=Omega$.

  Do đó,
  $
  E_t=cases( emptyset &: t< -1 , A^c &: -1<=t<1, Omega &: t>=1)
  $
  Vì $A in cal(M) =>A^c in cal(M)$. Hơn nữa, luôn có $emptyset in cal(M)$ và $Omega in cal(M)$, nên suy ra $E_t in cal(M)$. Vậy ta có điều phải chứng minh.

  *b)* Để viết hàm phân phối tích lũy $F_X (x)$, thì ta cần biết $P(A)$, do đó đặt $P(A)=p, 0<=p<=1 => P(A^c)=1-p$.
  Do đó, $
  F_X (x)=cases( 0 &: x< -1, 1-p &:-1<=x<1 ,1 &: x>=1).
  $

  Suy ra, ta có thể tìm được tập các điểm gián đoạn của $F_X$ là ${-1,1}$. Và $P(1)=p$, $P(-1)=1-p$. Do đó, với phân tích $F_X (x) =F(x)+G(x)$. Ta thu được
  $
  F(x)=sum_(x in D_x) 1_[x,infinity](x) P(X=x)=(1-p) 1_[-1,infinity)(x)+p 1_[1,infinity) (x)=cases(0  quad&: x< -1,1-p &: -1<=x< 1,1 &: x>=1 )
  $
  Do đó, $G(x)=F_X (x)-F(x)=0$. Vậy $X$ là b.n.n rời rạc.

  
  Suy ra, độ đo phân phối của $X$ là :
  $
  lambda_X(A)=(1-p) delta_(-1)(A)+p delta_1(A) +integral_A 0 dif x =(1-p) delta_(-1) (A) +p delta_1 (A)
  $

  *c)* Có $E X=(-1) (1-p)+p(1)=2p-1 => E X max=1 , E X min =-1$
]
#pagebreak()
== 2024-2025

#cau[
  *Câu 1. (3,0 điểm)*

  Có 15 quả bóng bàn, trong đó có 8 quả bóng chưa từng sử dụng. Chọn một quả bóng để chơi rồi trả lại hộp. Sau đó lại chọn ngẫu nhiên 1 quả trong hộp để chơi. Tìm xác suất để quả bóng được chọn là quả chưa từng sử dụng.
]

#cau[
  *Câu 2. (3,0 điểm)*

  Tính $E(X^2 (Y + 1))$ với $X, Y$ độc lập. Cho biết $"Var"(X) = 1$, $E X = 2$, $E Y = 3$.
]

#cau[
  *Câu 3. (4,0 điểm)*

  Cho $X$ là biến ngẫu nhiên có hàm phân phối tích lũy

  $ F_X(x) = cases(
    0 & quad x < 0,
    0.5x + 0.1 & quad 0 <= x < 0.5,
    0.8x & quad 0.5 <= x < 1,
    1 & quad x >= 1.
  ) $

  Tìm phân tích $F_X = F + G$ và viết công thức tính $lambda_X(A) = P(X in A)$ với mọi tập Borel $A in cal(B)(bb(R))$.
]
#v(1em)
#line(length: 100%, stroke: 0.8pt)
#v(0.8em)

#align(center)[
  #text(size: 10pt, weight: "bold")[
    _HƯỚNG DẪN GIẢI_
  ]
]
#loigiai[
  
*Câu 1)* Xét phép thử chọn một quả bóng. Khi đó, đặt $A$ là biến cố chọn được quả bóng chưa từng sử dụng, khi đó $overline(A)$ là biến cố chọn được quả bóng từng sử dụng.

Từ giả thiết, ta có $P(A)=8/15 => P(overline(A))=7/15$. Gọi $B$ là biến cố chọn được quả chưa từng sử dụng trong lần thứ hai. Khi đó, ta có, $P(B | A)=7/15$ và $P( B | overline(A))=8/15$. Nên, theo công thức xác suất toàn phần, ta có 
$
P(B)=P(B | A) P(A) + P (B |overline(A))P(overline(A))=7/15 times 8/15 +8 /15 times 7/15=0,4977....
$

*Câu 2)* Ta có $E(X^2(Y+1))=E(X^2 Y + X^2)=E(X^2) E(Y)+ E(X^2)=5 times 3 +5=20$.

*Câu 3)* Ta tìm $D_X$ là tập các điểm gián đoạn của $F_X$, khi đó có thể thấy $D_X={0,0.5,1}$. Và $P(X=0)=0.1,P(X=0.5)=0.05,P(X=1)=0.2$. Nên ta có, $
F(x)&=sum_(x in D_X) P(X=x) cal(1)_[x,infinity](x)=0.1times cal(1)_[0,infinity)(x)+0.15 times cal(1)_[0.5,infinity)(x) + 0.2 times cal(1)_[1,infinity)(x)\
&=cases(0 &: quad x<0,0.1 &: quad 0<=x<0.5, 0.15 &: quad 0.5<=x<1, 0.35 &quad x>=1 )


$
Do đó, lấy $
F_X ( x)-F(x)=G(x)= cases(0 &: quad x<0, 0.5x &: quad 0<=x<0.5 , 0.8x -0.15 &: quad 0.5<=x<1, 0.65 &: quad x>=1). => g(x)=G'(x)= cases(0.5 &: quad 0<=x<0.5,0.8 &:quad 0.5<=x<1,0 &: quad "Các trường hợp còn lại")


$
Vậy , $F_X=F+G$. Hơn nữa, có $
lambda_X(A)= P(X in A)= 0.1 times delta_(0)(A)+0.05 times delta_(0.5)(A) + 0.2 times delta_(1) (A)+ integral_A g(x) d x quad (forall A in cal(B(RR))).
$

]

#pagebreak()
== 2023-2024

#cau[
  *(2,0 điểm)*

  Tất cả những người tham gia khóa học "bỏ hút thuốc" mà vẫn không hút thuốc trong suốt khoảng thời gian một năm sau được mời dự tiệc liên hoan. Trong số nữ tham gia khóa học, có 49% được mời và trong số nam tham gia khóa học có 38% được mời. Nếu 63% số người tham gia lớp học ban đầu là nam, tính:

  a) Tỷ lệ phần trăm của lớp học ban đầu tham gia bữa tiệc.

  b) Tỷ lệ phần trăm những người tham dự bữa tiệc là nữ.
]

#cau[
  *(2,0 điểm)*

  Cho không gian xác suất $(Omega, cal(M), bb(P))$. Cho $A_1, ..., A_n$ là các biến cố. Giả sử

  $ P(A_1 inter ... inter A_(n-1)) > 0. $

  Chứng minh

  $ P(A_1 inter ... inter A_n)
    = P(A_1) P(A_2 | A_1) ...
    P(A_n | A_1 inter ... inter A_(n-1)). $
]

#cau[
  *(2,0 điểm)*

  Một hộp chứa 6 quả bóng trắng và 9 quả bóng đen. Lần lượt lấy ra, không hoàn lại, 4 quả bóng. Tính xác suất để được 2 quả đầu là trắng và 2 quả sau là đen.
]

#cau[
  *(2,0 điểm)*

  Cho

  $ F(x) = integral_(-infinity)^x f(t) dif t. $

  Tìm (gần đúng) độ đo Radon-Nikodym $mu_F([-2, 4])$ biết

  $ f(x) = cases(
    1/2 x^2 e^(-x) & x > 0,
    0 & x <= 0.
  ) $
]

#cau[
  *(2,0 điểm)*

  Theo các nghiên cứu khoa học, chỉ có 0,01% trứng cá hồi có thể phát triển thành một con cá trưởng thành. Giả sử việc trưởng thành của các con cá hồi là độc lập lẫn nhau. Trong một trang trại, người ta thả 50.000 trứng. Hỏi có bao nhiêu khả năng thu được ít nhất ba con cá trưởng thành?
]
#v(1em)
#line(length: 100%, stroke: 0.8pt)
#v(0.8em)

#align(center)[
  #text(size: 10pt, weight: "bold")[
    _HƯỚNG DẪN GIẢI_
  ]
]

#loigiai[

  *Câu 1 : * Gọi $A$ là biến cố nữ tham gia khóa học, B là biến cố tham gia bữa tiệc. Từ giả thiết, ta có $
  P(A)=0.37, quad P(B|A)=0.49,  quad P(B|overline(A))=0.38
  $
  *a)* Áp dụng công thức xác suất toàn phần, ta có
  $
  P(B)=P(A) times P(B |A)+ P(B| overline(A)) times P(overline(A))=0.37 times 0.49 + 0.38 times 0.63=0.4207
  $
  *b)* Áp dụng công thức Bayes, ta cần tính
  $
  P(A|B)=(P(B|A)P(A))/(P(B))=(0.37 times 0.49)/(0.4207)=0.4309
  $

  *Câu 2 :* Ta chứng minh công thức trên bằng nguyên lý quy nạp, thật vậy.

  Với $n=2$, thì luôn có $P(A_1 inter A_2)=P( A_2 | A_1) P(A_1)$.

  Giả sử, đúng với $n=k in NN$, nghĩa là
  $
  P(A_1 inter A_2 dots inter A_k)=P(A_1) P(A_2 | A_1)dots P(A_k|A_1 inter A_2 dots A_k).
  $
  Ta chứng minh đúng với $n=k+1$, thật vậy có $P(A_1 inter A_2 ...inter A_(n-1))>0 => P(A_1 inter A_2... inter A_k)>0$. Do đó,

  $
  P(A_1 inter A_2... inter A_(k+1))=P((A_1 inter A_2... inter A_k) inter A_(k+1))=P(A_(k+1) | A_1 inter... A_n) P(A_1 inter A_2.. inter A_n)
  $
  Từ giả thiết đúng với $n=k in NN$, khi đó ta suy ra
  $
  P(A_1 inter A_2... inter A_(k+1))=P(A_1) P(A_2 |A_1)... P(A_k |A_1 inter A_2... inter A_k)P(A_(k+1)| A_1 inter A_2..inter A_k)
  $
  Ta có điều phải chứng minh.

  *Câu 3* Gọi $A$ là biến cố lấy được $2$ quả đầu là trắng , $2$ quả sau là đen là. Ta có,
  $
  P(A)=6/15 times 5/14 times 9/13 times 8/12=0.07
  $

  *Câu 4*
  Độ đo cần tính là :
  $
  integral_(-2) ^ 4 f(x) dif x= integral_0
^4 1/2  x^2 e^(-x) dif x =0.76 $

  *Câu 5* Gọi $A$ là biến cố thu được ít nhất $3$ con trưởng thành, khi đó $P(A)=1-P(A)$, trong đó với $X$ là biến cố thu được một con cá trưởng thành, thì $P(A)=P(X>=3)=1-P(X<3)=1-P(X=0)-P(X=1)-P(X=2)=1-(0.999)^(5000)-C_50000 ^1 (0.0001) (0.999)^(4999) - C_50000^2 (0.0001)^2 (0.999)^4998=0.989$.
]
#pagebreak()
== 2022-2023

#cau[
  *(2,0 điểm)*

  Trong một trường đại học, có 53% sinh viên là nữ, 5,5% sinh viên học chuyên ngành khoa học máy tính và 2% sinh viên là nữ học chuyên ngành khoa học máy tính. Chọn ngẫu nhiên một sinh viên. Tính xác suất để:

  (a) Sinh viên được chọn là nữ biết rằng sinh viên này học chuyên ngành khoa học máy tính.

  (b) Sinh viên này học chuyên ngành khoa học máy tính biết rằng sinh viên này là nữ.
]

#cau[
  *(2,0 điểm)*

  Cho không gian xác suất $(Omega, cal(M), bb(P))$. Chứng minh rằng nếu $A, B in cal(M)$ là hai biến cố độc lập thì các cặp biến cố $A^c, B$ và $A^c, B^c$ cũng độc lập.
]

#cau[
  *(2,0 điểm)*

  Cho không gian đo $(Omega, cal(M), bb(P))$. Cho $f: Omega -> bb(R)$, $g: Omega -> bb(R)$ là các hàm đo được.

  (a) Chứng minh $f^(-1)((3,4)) inter g^(-1)((2,5))$ là tập đo được trên $Omega$.

  (b) Cho $x in f^(-1)((3,4)) inter g^(-1)((2,5))$. Chứng minh

  $ 6 < f(x) g(x) < 20. $
]

#cau[
  *(2,0 điểm)*

  Cho độ đo $phi$ xác định trên $(bb(R), cal(B)(bb(R)))$ với

  $ phi(A) = integral_A 1/sqrt(2 pi) e^(-t^2/2) dif m(t) $

  với mọi $A in cal(B)(bb(R))$.

  Tính gần đúng

  $ integral_((-1,1)) t^2 dif phi(t). $
]

#cau[
  *(2,0 điểm)*

  (a) Khối lượng một gói rau bán tại một siêu thị rau sạch là biến ngẫu nhiên có phân phối chuẩn với trung bình 550 g và độ lệch chuẩn 20 g. Trong một ngày có 2000 gói rau được bán. Ước lượng số rau mà trọng lượng của nó $> 580$ g.

  (b) Tại một siêu thị gần đó, 16% gói rau được bán có trọng lượng ít nhất 590 g và 11% rau được bán có trọng lượng $< 540$ g. Giả sử trọng lượng rau $M$ của các gói rau của siêu thị này tuân theo phân phối chuẩn. Tìm trung bình và độ lệch chuẩn của $M$.
]
#v(1em)
#line(length: 100%, stroke: 0.8pt)
#v(0.8em)

#align(center)[
  #text(size: 10pt, weight: "bold")[
    _HƯỚNG DẪN GIẢI_
  ]
]
#loigiai[

  *Câu 1* 
  
  Xét phép thử chọn ngẫu nhiên một sinh viên. Gọi $A$ là biến cố sinh viên được chọn là nữ, B là biến cố sinh viên được chọn học chuyên ngành khoa học máy tính. Từ giả thiết, ta có
  $
  P(A)&= 53 %=>P(A^c)=1-P(A)=47%\
  P(B)&=5.5% , P(A B)=2% 
  
  $
  *a)* Xác suất cần tìm là
  $
  P(A | B)= P(A B)/ P(B)=4/11
  $
  *b)* Ta cần tìm $P(B |A)$, áp dụng công thức Bayes, ta có
  $
  P(B|A)=P(A B)/P(A)=(5.5%)/(53%)=11/106
  $

  *Câu 2*

  Giả sử $A,B in cal(M)$ là các biến cố độc lập, ta chứng minh $A^c,B$ độc lập. Thật vậy, có $A inter B union A^c inter B=B$, hơn nữa $A inter B inter A^c inter B= emptyset$. Do đó, theo tính cộng tính của độ đo $P$ trên $cal(M)$, ta có $
  P(A B)+P(A^c B)=P(B) => P(A^c B)=P(B)(1-P(A))=P(B) P(A^ c)=> A^c,B "là hai biến cố độc lập".
  $
  Có, $A^c inter B^c union A^c inter B=A^c$, lập luận tương tự như trên, ta thu được
  $
  P(A^c B^c)=(1-P(A))(1-P(B))=P(A^c)P(B^c)
  $

  *Câu 3*

  *a)* Có $f^(-1)(3,4)={x in Omega : 3<f(x)<4} "là tập đo được"$. Vì $f$ là hàm đo được, lập luận tương tự với $g$, ta thu được giao của $2$ tập đo được thì đo được, ta có điều phải chứng minh.

  *b)* Từ $x in f^(-1) (3,4) => 3<f(x)<4$, mặt khác lại có $x in g^(-1) (2,5) => 3times 2<f(x)g(x)<4 times 5 <=> 6 <f(x) g(x)<20$.

  *Câu 4*
  Vì độ đo $phi$ có mật độ
$
  f(t) = 1/sqrt(2 pi) e^(-t^2/2)
$
đối với độ đo Lebesgue $m$ trên $bb(R)$, nên ta có
$
  integral_(-1,1) t^2 dif phi(t)
  &= integral_(-1,1) t^2 f(t) dif m(t) \
  &= 1/sqrt(2 pi) integral_(-1)^1 t^2 e^(-t^2/2) dif t.
$

Do hàm số $t^2 e^(-t^2/2)$ là hàm chẵn, suy ra
$
  integral_(-1,1) t^2 dif phi(t)
  = 2/sqrt(2 pi) integral_0^1 t^2 e^(-t^2/2) dif t.
$

Tính gần đúng tích phân, ta được
$
    integral_(-1,1) t^2 dif phi(t) approx 0.198748
$

*Câu 5*

*(a)*

Gọi $X$ là khối lượng của một gói rau (đơn vị: g).

Theo giả thiết, ta có
$
  X ~ cal(N)(550, 20^2).
$

Đặt
$
  Z = (X - 550)/20 ~ cal(N)(0,1).
$

Khi đó,
$
  P(X > 580)
  &= P((X - 550)/20 > (580 - 550)/20) \
  &= P(Z > 1.5) \
  &= 1 - Phi(1.5) \
  &approx 0.066807.
$

Vậy số gói rau có khối lượng lớn hơn $580$ g được ước lượng là
$
  (2000 times 0.066807 approx 134 " gói").
$

*(b)*

Theo giả thiết, ta có
$
  M ~ cal(N)(mu, sigma^2),
$
trong đó $mu$ và $sigma > 0$ lần lượt là trung bình và độ lệch chuẩn cần tìm.

Đặt
$
  Z = (M - mu)/sigma ~ cal(N)(0,1).
$

Vì $16%$ gói rau có khối lượng ít nhất $590$ g nên
$
  P(M >= 590) = 0.16.
$

Suy ra
$
  P(M < 590) = 0.84.
$

Do đó,
$
  P(Z < (590 - mu)/sigma) = 0.84.
$

Tra bảng phân phối chuẩn, ta được
$
  (590 - mu)/sigma approx 0.99446. quad (1)
$

Mặt khác, vì $11%$ gói rau có khối lượng nhỏ hơn $540$ g nên
$
  P(M < 540) = 0.11.
$

Suy ra
$
  P(Z < (540 - mu)/sigma) = 0.11.
$

Tra bảng phân phối chuẩn, ta được
$
  (540 - mu)/sigma approx -1.22653. quad (2)
$

Lấy $(1)$ trừ $(2)$, ta có
$
  50/sigma approx 0.99446 + 1.22653.
$

Suy ra
$
  sigma approx 50/2.22099 approx 22.51.
$

Thay vào $(1)$, ta được
$
  mu &approx 590 - 0.99446 times 22.5125 \
     &approx 567.61.
$

Vậy trung bình và độ lệch chuẩn của $M$ lần lượt là
$
  (mu approx 567.61 " g", quad sigma approx 22.51 " g").
$
]
#pagebreak()
== Đề Luyện Tập
=== Đề 1
#cau[
  *Câu 1. (3,0 điểm)*
  
  Một hộp có 10 quả bóng, trong đó 6 quả chưa từng dùng. Trước khi chơi, người quản trò chọn một trong hai quy tắc và giữ nguyên cho cả hai lượt. Quy tắc $R$ được chọn với xác suất $2/3$: sau lượt đầu, trả quả bóng đã dùng về hộp. Quy tắc $K$ được chọn với xác suất $1/3$: sau lượt đầu, bỏ quả bóng đã dùng ra ngoài. Mỗi lượt chọn đều ngẫu nhiên một quả từ các quả đang có trong hộp. Quả đã dùng sẽ mất trạng thái “chưa từng dùng” ngay sau lượt chơi.

  (a) (1,5 điểm) Tính xác suất quả bóng được chọn ở lượt hai chưa từng dùng tại thời điểm chọn.

  (b) (1,5 điểm) Biết quả được chọn ở lượt hai chưa từng dùng tại thời điểm chọn. Tính xác suất đã dùng quy tắc $K$ và quả được chọn ở lượt đầu cũng chưa từng dùng tại thời điểm chọn.
]

#cau[
  *Câu 2. (3,0 điểm)*

  Cho $X,Y$ độc lập, có momen cấp hai hữu hạn. Biết $E X=1$, $E Y=-2$, $"Var"(X)=2$ và $"Var"(Y)=3$. Đặt $U=X+Y$ và $V=2X-Y$.

  (a) (1,0 điểm) Tính $E(X^2 (Y+3))$ và $"Cov"(U,V)$.

  (b) (2,0 điểm) Tìm $t in bb(R)$ làm nhỏ nhất $E((U-t V)^2)$ và tính giá trị nhỏ nhất. Giải thích vì sao kết quả có thể khác giá trị $t$ làm nhỏ nhất $"Var"(U-t V)$.
]

#cau[
  *Câu 3. (4,0 điểm)*

  Cho hàm
  $ F(x) = cases(
    0 & x < 0,
    a + x/5 quad& 0 <= x < 1,
    b + x^2/10 quad& 1 <= x < 2,
    1 & x >= 2,
  ) $
  Biết $F$ là hàm phân phối tích lũy của $X$, $F$ liên tục tại $1$ và $E X=7/6$.

  (a) (2,0 điểm) Tìm $a,b$. Chỉ ra các điểm nhảy của $F$ và độ lớn mỗi bước nhảy.

  (b) (2,0 điểm) Phân tích $F=F_d+F_c$, trong đó $F_d$ là phần bậc thang và $F_c$ là phần liên tục, cả hai tiến về $0$ khi $x$ tiến về $-infinity$. Viết $lambda_X (D)=P(X in D)$ cho mọi $D in cal(B)(bb(R))$. Tính $P(0<X<=2 | X>=1)$.
]
#v(1em)
#line(length: 100%, stroke: 0.8pt)
#v(0.8em)

#align(center)[
  #text(size: 10pt, weight: "bold")[
    _HƯỚNG DẪN GIẢI_
  ]
]
#loigiai[

  *Câu 1* Xét phép thử chọn ngẫu nhiên một quả bóng. Gọi A là biến cố người quản trò chọn quy tắc $R$. Gọi B là biến cố quả bóng được chọn ở lượt hai chưa từng dùng tại thời điểm chọn. Gọi $C$ là biến cố quả bóng được chọn ở lần thứ nhất chưa từng dùng, từ giả thiết ta có
  $
  P(C | A)&=6/16 = P( C| A^c) ; P(B | A  C)=5/16; P( B | A C^c)=6/16\
  P(B|A^c C)&=5/15;  P(B| A^c C^c)=6/15
  $
  *a)* Áp dụng công thức xác suất toàn phần, ta được
  $
  P(B)&=P(C|A) P(A) times P(B| A C)+P(C^c |A) times P(A) times P(B| A C^c)\ &+ P(C|A^c) P(A^c)times P(B |A^c C)+ P(A^c) times P(C^c | A^c) times P(B^c | A^c C^c)
  \
  &=6/16 times 2/3 times 5/16 + 8/16 times 2/3 times 6/16 +1/3 times 6/16 times 5/15 + 1/3 times 8/16
 times 6/15=299/960  $

 *b)* Áp dụng công thức Bayes, ta có xác suất cần tìm là
 $
 P(A^c C|B)= (P(A^ c C B) )/(P(B))=(P(A^c C)P(B|A^c C) ) /P(B)=40/299
 $

 *Câu 2*

 *a)* Có $E(X^2(Y+3))=E(X^2 Y +3 X^2)=E(X^2)E(Y)+ 3E (X^2)=1 times -2 +3=1$, vì $v a r(X)=E(X^2)-(E(X))^2=> E(X^2)=1$.

 Có $
 C o v(U,V)=E(U V)-E(U)(E V)&=E((X+Y)(2 X -Y))-E(X+Y)E(2X-Y)\
 &= E(2X^2+Y X-Y^2)- [(E(X)+E(Y))] (E(2 X)- E(Y))\
 &=2 E(X^2)+E (X) E(Y) - E(Y^2)-(1-2) times(2+2)\
 &=2times 1+1 times-2 - 7 +4=-3
 $

 *b)* Với $t in RR$, ta có
 $
 E(U-t V)^2=E(U^2-2 t U V+t^2 V^2)=t^2 E(V^2)-2 t E(U V)+E(U^2)= f(t)
 $
 Khi đó, $f(t)$ đạt min khi và chỉ khi $t=-b/(2a) ,"i.e" t=E(U V)/E(V^2)$. Trong đó,
 $
 E(U V)=-7 "và" E(V^2)=E((2X-Y)^2)=E(4 X^2-4 X Y +Y^2)=4 E(X^2)-4 E(X) E(Y)+ E(Y^2)=19 => t=-7/19
 $

 Do đó, $f_min=f(t)=(-7/19)^2 times E(V^2)+ 14/19 times E(U V)+ E(U^2)=$

 
Có $V  a r(U - t V)= E((U-t V^2))-(E(U-t V))^2$, do đó nếu chọn $$
  


*Câu 3*

Từ giả thiết, với $F$ là hàm phân phối tích lũy của $X$, hơn nữa có $F$ liên tục tại $1$, suy ra

]
#pagebreak()
=== Đề 2

#cau[
  *Câu 1. (5,0 điểm)*

  Một phòng xét nghiệm nhận mẫu từ ba nguồn $S_1,S_2,S_3$ với tỉ lệ lần lượt là $1/2$, $1/3$, $1/6$. Lấy một mẫu ngẫu nhiên. Với mẫu từ nguồn $S_i$, một lần kiểm tra cho kết quả dương tính với xác suất $q_i$, trong đó $q_1=1/5$, $q_2=1/2$, $q_3=4/5$. Khi biết nguồn của mẫu, các lần kiểm tra trên cùng mẫu độc lập và có cùng xác suất dương tính.

  (a) (1,5 điểm) Tính xác suất trong hai lần kiểm tra đầu có đúng một lần dương tính.

  (b) (1,5 điểm) Biết trong hai lần kiểm tra đầu có đúng một lần dương tính. Tính xác suất lần thứ ba dương tính và xác suất mẫu đến từ nguồn $S_3$.

  (c) (2,0 điểm) Gọi $D_i$ là biến cố lần kiểm tra thứ $i$ dương tính. Kiểm tra tính độc lập của $D_1,D_2$ khi chưa biết nguồn. Sau đó, với một mẫu đã có $n$ lần dương tính liên tiếp, viết xác suất có điều kiện mẫu thuộc $S_3$ và tìm $n$ nguyên dương nhỏ nhất để xác suất này ít nhất bằng $0.9$.
]

#cau[
  *Câu 2. (5,0 điểm)*

  Trên $(bb(R),cal(B)(bb(R)))$, cho độ đo xác suất
  $ P = 1/4 delta_0 + 1/4 delta_1 + 1/2 1_((0,1))(x) dif x. $
  Đặt $X(omega)=omega$ và $Y=abs(2 X-1)$.

  (a) (1,0 điểm) Chứng minh $Y$ là biến ngẫu nhiên và xác định toàn bộ các điểm có xác suất dương của $Y$.

  (b) (2,0 điểm) Tìm $F_Y(y)$ trên toàn trục số. Viết độ đo phân phối $lambda_Y(D)$ cho mọi tập Borel $D$.

  (c) (2,0 điểm) Tính $E Y$, $"Var"(Y)$ và $"Cov"(X,Y)$. Xét tính độc lập của $X,Y$, giải thích bằng hai biến cố cụ thể.
]

#pagebreak()
=== Đề 3

#cau[
  *Câu 1. (3,0 điểm)*

  Trên $Omega = {1,2,3,4,5,6,7,8}$, đặt $C={1,2,3,4}$, $D={1,2,5,6}$ và $cal(F)=sigma({C,D})$. Giả sử $P(C)=0.6$, $P(D)=0.5$ và $P(C inter D)=0.35$.

  (a) (1,5 điểm) Mô tả mọi phần tử của $cal(F)$ dưới dạng hợp của các khối rời nhau nhỏ nhất và tìm xác suất từng khối. Có thể xác định $P({1,3})$ từ không gian xác suất đã cho hay không? Giải thích.

  (b) (1,5 điểm) Gọi $cal(G)=sigma(cal(F) union {{1,3}})$. Hãy mô tả tất cả giá trị có thể của $P^*({1,3})$ khi $P^*$ chạy qua mọi độ đo xác suất trên $cal(G)$ trùng với $P$ trên $cal(F)$. Chứng minh mọi giá trị tìm được đều đạt được.
]

#cau[
  *Câu 2. (3,0 điểm)*

  Cho $X,Y$ độc lập, có cùng hàm phân phối tích lũy
  $ F(x)=cases(0 & x<0, x^2  quad& 0<=x<1, 1 & x>=1). $
  Đặt $U=min(X,Y)$ và $V=max(X,Y)$.

  (a) (1,5 điểm) Tìm $F_U(t), F_V(t)$ trên toàn trục số và tính $P(U>1/2, V<=3/4)$.

  (b) (1,5 điểm) Tính $E U$, $E V$ và $"Cov"(U,V)$. Có thể dùng đẳng thức $U V=X Y$.
]

#cau[
  *Câu 3. (4,0 điểm)*

  Cho hai biến ngẫu nhiên $X,Y$ độc lập. Với $t in bb(R)$, hàm sinh momen của chúng là
  $ M_X(t)=(1+2 e^t+e^(2t))/4, quad M_Y(t)=(e^(-t)+2+e^t)/4. $

  (a) (2,0 điểm) Xác định độ đo phân phối của $X$ và $Y$. Giải thích vì sao hàm sinh momen cho phép nhận dạng hai phân phối này.

  (b) (2,0 điểm) Đặt $Z=X+2Y$. Tìm $M_Z(t)$, tính $P(Z=0)$ và $"Var"(Z)$. Giải thích cách đọc $P(Z=0)$ từ biểu thức $M_Z(t)$.
]

#pagebreak()
=== Đề 4

#cau[
  *Câu 1. (5,0 điểm)*

  Một thiết bị thuộc loại tốt $T$ với xác suất $p$ và loại lỗi $L$ với xác suất $1-p$, trong đó $0<p<1$. Biết loại thiết bị, các phép kiểm tra độc lập. Xác suất một phép kiểm tra cho kết quả đạt là $3/4$ với loại $T$ và $1/4$ với loại $L$.

  (a) (1,5 điểm) Tính xác suất thiết bị thuộc loại tốt khi biết trong hai phép kiểm tra đầu có ít nhất một lần đạt. Viết kết quả theo $p$.

  (b) (2,0 điểm) Gọi $H$ là biến cố hai phép kiểm tra đầu cho kết quả giống nhau. Chứng minh $H$ độc lập với biến cố thiết bị thuộc loại tốt. Với điều kiện $H$ đã xảy ra, tính xác suất phép kiểm tra thứ ba cho kết quả đạt.

  (c) (1,5 điểm) Người kiểm tra dừng ngay khi có kết quả đạt lần đầu. Gọi $A_n$ là biến cố $n$ phép kiểm tra đầu đều không đạt. Dùng tính liên tục của độ đo xác suất để tính xác suất quy trình không bao giờ dừng. Tìm giới hạn của $P(T | A_n)$ khi $n$ tiến đến vô cùng và giải thích kết quả.
]

#cau[
  *Câu 2. (5,0 điểm)*

  Cho $X,Y$ độc lập và có cùng độ đo phân phối
  $ lambda = 1/4 delta_(1/2) + 3/4 1_((0,1))(x) dif x. $
  Đặt $S=X+Y$.

  (a) (1,5 điểm) Tìm $M_X(t)$ và $M_S(t)$, ghi rõ giá trị tại $t=0$.

  (b) (2,0 điểm) Chứng minh $S$ có đúng một điểm mang xác suất dương và tìm xác suất tại điểm đó. Sau đó tính $P(S<=1/2)$.

  (c) (1,5 điểm) Tính $E S$ và $"Var"(S)$. Tính $P(S<1)$ bằng cách khai thác tính đối xứng của phân phối quanh $1$.
]
#pagebreak()

=== Đề 5

#cau[
  *Câu 1. (2,0 điểm)*

  Một phương pháp xét nghiệm có khả năng phát hiện đúng bệnh ở 93% người mắc bệnh và cho kết quả dương tính ở 6% người không mắc bệnh. Biết rằng tỷ lệ mắc bệnh trong cộng đồng là 4%.

  a) Tính xác suất để một người được chọn ngẫu nhiên có kết quả xét nghiệm dương tính.

  b) Một người có kết quả xét nghiệm dương tính. Tính xác suất người đó thực sự mắc bệnh.

  c) Nếu một người có kết quả xét nghiệm âm tính thì xác suất người đó không mắc bệnh là bao nhiêu?
]

#cau[
  *Câu 2. (1,5 điểm)*

  Cho $X, Y$ là hai biến ngẫu nhiên độc lập, thỏa mãn
  $
    E X = -1, quad V a r(X) = 2,
  $
  $
    E Y = 3, quad V a r(Y) = 1.
  $

  Tính
  $
    E ((X + 2)^2 (Y - 1)).
  $
]

#cau[
  *Câu 3. (3,0 điểm)*

  Cho $X$ là biến ngẫu nhiên có hàm phân phối tích lũy
  $
    F_X(x) = cases(
      0 quad& x < 0,
      1/5 & 0 <= x < 1,
      1/5 + 2/5 (x - 1)^2 quad&  1 <= x < 2,
      1 & x >= 2.
    )
  $

  a) Xác định các điểm gián đoạn của $F_X$ và tính xác suất $P(X = x)$ tại các điểm đó.

  b) Phân tích $F_X = F + G$, trong đó $F$ là thành phần rời rạc và $G$ là thành phần liên tục.

  c) Viết công thức tính độ đo phân phối
  $
    lambda_X(A) = P(X in A)
  $
  với mọi $A in cal(B)(bb(R))$.

  d) Sử dụng độ đo phân phối vừa tìm được để tính $E X$.
]

#cau[
  *Câu 4. (2,0 điểm)*

  Một nền tảng thương mại điện tử có hai nhóm khách hàng $A$ và $B$. Tỷ lệ khách hàng thuộc nhóm $A$ là $p$.

  Đối với nhóm $A$, tỷ lệ khách hàng mua ngay, thêm vào giỏ hàng và không tương tác lần lượt là $0.4$, $0.35$, $0.25$.

  Đối với nhóm $B$, các tỷ lệ tương ứng là $0.2$, $0.3$, $0.5$.

  a) Tìm hàm $f(p)$ biểu diễn xác suất một khách hàng được chọn ngẫu nhiên thực hiện hành động mua ngay.

  b) Xác định miền xác định, tập giá trị của $f$ và vẽ đồ thị hàm số.

  c) Biết tỷ lệ khách hàng mua ngay trên toàn nền tảng là $0.32$. Tính xác suất một khách hàng thuộc nhóm $A$, biết rằng người đó đã mua ngay.
]

#cau[
  *Câu 5. (1,5 điểm)*

  Cho không gian xác suất $(Omega, cal(M), P)$ và hai tập $A, B subset.eq Omega$ sao cho $A inter B = emptyset$.

  Xét hàm
  $
    X(omega) = cases(
      -1 quad& omega in A,
      2 & omega in B,
      0 & omega in.not A union B.
    )
  $

  a) Chứng minh rằng $X$ là biến ngẫu nhiên khi và chỉ khi $A, B in cal(M)$.

  b) Giả sử $P(A) = a$, $P(B) = b$. Viết hàm phân phối tích lũy $F_X$, độ đo phân phối $lambda_X$ và tính $E X$.
]
#loigiai[

  *Câu 1* 
  
  Xét phép thử chọn ngẫu nhiên một người có kết quả xét nghiệm. Gọi $B$ là biến cố người được chọn có kết quả dương tính. Gọi $A$ là biến cố người được chọn thật sự mắc bệnh. Khi đó, từ giả thiết, ta có
  $
  P(A)=0.04 quad P(B|A)=0.93 quad P(B|A^c)=0.06 quad P(A^c)=0.96
  $
  *a)* Áp dụng công thức xác suất toàn phần, xác suất cần tìm là 
  $
  P(B)=P(A) times P(B|A) + P(A^c) times P(B|A^c)=0.04 times 0.93 + 0.06 times 0.96=0.0948
  $
  *b)* Áp dụng công thức Bayes, xác suất cần tìm là 

  $
  P(A|B)=(P(B|A) P(A))/ (P(B))=(0.93 times 0.04)/(0.04 times 0.93 + 0.06 times 0.96)= 31/79
  $

  *c)* Áp dụng công thức Bayes, xác suất cần tìm là
  $
  P(A^c|B^c)=(P(A^c B^c))/(P(B^c))=(P(A^c) P(B^c|A^c))/(P(B^c))=(0.96times(1-0.06))/(1-0.0948)=0.99
  $

  *Câu 2*

  Có : $
  E((X+2)^2(Y-1))=E(X+2)^2times E(Y-1) "vì X,Y là 2 b.n.n độc lập"
  $
  Lại có, $V a r(X)=2 => E(X^2)=V a r(X)-(E(X))^2=2-1=1$.

  Do đó,
  $
  E(X+2)^2=E(X^2+4 X +4)=E(X^2)+4 E(X)+4=1+4+4=9\

  E(Y-1)=E(Y)-1=2 => E(X+2)^2 times E(Y-1)=18
  $
  *Câu 3*

  Xét
  $
    F_X (x) = cases(
      0 quad& x < 0,
      1/5 & 0 <= x < 1,
      1/5 + 2/5 (x - 1)^2 quad&  1 <= x < 2,
      1 & x >= 2.
    )
  $
  *a)* Do đó, tập các điểm gián đoạn của $F$ là $D_f={0,2}$. Và $P(X=0)=1/5 , P(X=2)=2/5$.

  *b)* Với phân tích $F_x=F+G$, khi đó 
  $
  F(x)=sum_(x in D_f) 1_[x,infinity) P(X=x)=1/5times 1_[0,infinity) + 2/5 times 1_[2,infinity)\

  =cases(0 &: x<0 ,1/5  quad &:0<=x<2,3/5 &: x>=2)
  $
  Vậy, $
  G=F_X -F=cases(0 &: x<0,0 &: 0<=x<1 , 2/5 (x-1)^2 &: 1<=x<2 , 2/5 &: x>=2)
  $
 Hơn nữa,
   $
  g(x)=G'(x)=cases(0 quad&: x<=0, 0 &: 0<=x<1,4/5(x-1) &: 1<=x<2 ,0 &: x>=2 )
  $

  *c)* Từ câu b), ta có
  $
  lambda_X (A)=P(X=0) times lambda_(0)(A) + P(X=2) times lambda_(2) (A) +integral_A g(x) dif x=1/5 times lambda_0(A)+2/5 times lambda_2(A)+integral_A g(x) dif x
  $

  *d)*

  *Câu 5*

  *a)*
  Xét $A,B subset.eq Omega$ và $A inter B= emptyset$ và 
  $
  X(omega)=cases( -1 quad &: omega in A, 2 quad &: omega in B, 0 &:omega in.not A union B)
  $
  
  
  *=>)* Giả sử $X$ là b.n.n khi đó ta chứng minh $A,B in cal(M)$. Thật vậy, vì $X$ là b.n.n nên với bất kỳ $t in RR$.

  $
  E_t={omega in Omega : X(omega)<=t}in cal(M)
  $

  Do đó, xét $t=2$, thì 
  

  
]
#pagebreak()
=== Đề 6

#cau[
  *Câu 1. (2,0 điểm)*

  Một nhà máy sản xuất linh kiện điện tử sử dụng ba dây chuyền $A, B, C$, đóng góp lần lượt 50%, 30% và 20% tổng sản lượng.

  Tỷ lệ sản phẩm lỗi của ba dây chuyền lần lượt là 2%, 5% và 10%.

  a) Chọn ngẫu nhiên một sản phẩm từ nhà máy. Tính xác suất sản phẩm đó bị lỗi.

  b) Biết sản phẩm được chọn bị lỗi. Tính xác suất sản phẩm đó được sản xuất bởi dây chuyền $C$.

  c) Một sản phẩm được chọn không bị lỗi. Tính xác suất nó được sản xuất bởi dây chuyền $A$.
]

#cau[
  *Câu 2. (1,5 điểm)*

  Cho hai biến ngẫu nhiên $X, Y$ độc lập và
  $
    E X = 2, quad V a r(X) = 3,
  $
  $
    E Y = -1, quad V a r(Y) = 4.
  $

  Tính
  $
    E ((X^2 - X)(Y^2 + 2)).
  $
]

#cau[
  *Câu 3. (3,0 điểm)*

  Cho $X$ là biến ngẫu nhiên có hàm phân phối tích lũy
  $
    F_X(x) = cases(
      0 & x < -2,
      1/4 & -2 <= x < -1,
      1/4 + 1/4 (x + 1) quad & -1 <= x < 1,
      1 & x >= 1.
    )
  $

  a) Tìm tất cả các giá trị $x in bb(R)$ sao cho $P(X = x) > 0$.

  b) Tìm thành phần rời rạc và thành phần liên tục của $F_X$.

  c) Biểu diễn độ đo phân phối của $X$ thông qua độ đo Dirac và độ đo Lebesgue.

  d) Dựa trên độ đo phân phối, tính
  $
    P(-1 < X <= 1), quad E X.
  $
]

#cau[
  *Câu 4. (2,0 điểm)*

  Một hệ thống nhận diện có thể phân loại một đối tượng vào một trong ba nhóm $G_1, G_2, G_3$.

  Có hai loại dữ liệu đầu vào $A, B$, với xác suất đầu vào thuộc loại $A$ là $p$.

  Khi đầu vào thuộc loại $A$, xác suất được phân loại vào $G_1, G_2, G_3$ lần lượt là
  $
    0.6, quad 0.3, quad 0.1.
  $

  Khi đầu vào thuộc loại $B$, các xác suất tương ứng là
  $
    0.2, quad 0.5, quad 0.3.
  $

  a) Tìm các điều kiện đối với $p$ để mô hình xác suất hợp lệ.

  b) Tìm hàm $f(p)$ biểu diễn xác suất một đầu vào được phân loại vào $G_1$. Chứng minh $f$ đơn điệu trên miền xác định.

  c) Biết rằng xác suất một đầu vào được phân loại vào $G_1$ bằng $0.44$. Tính xác suất đầu vào thuộc loại $B$, biết rằng nó được phân loại vào $G_1$.
]

#cau[
  *Câu 5. (1,5 điểm)*

  Cho không gian xác suất $(Omega, cal(M), P)$ và hai tập $A, B in cal(M)$. Đặt
  $
    X = I_A + I_B,
  $
  trong đó $I_A, I_B$ là các hàm chỉ mục.

  a) Chứng minh $X$ là biến ngẫu nhiên và xác định tập các giá trị mà $X$ có thể nhận.

  b) Viết độ đo phân phối của $X$ theo $P(A)$, $P(B)$ và $P(A inter B)$.

  c) Sử dụng định nghĩa kỳ vọng theo tích phân Lebesgue để chứng minh
  $
    E X = P(A) + P(B).
  $
]