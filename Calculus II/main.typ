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

#let color-ex = rgb("#334155") // Xanh cổ vịt đậm
#let bg-ex = rgb("#f8fafc")    // Xanh bạc hà nhạt


#let color-text = rgb("#005a8c")  // Màu chữ cho Chứng minh/Lời giải

#let thm-counter = counter("theorem")

// ==========================================
// HÀM TEMPLATE CHÍNH
// ==========================================
#let template(
  title: none,
  subtitle: none,
  author: none,
  body,
) = {
  // Bật font Euler cho công thức toán học
  show math.equation: set text(font: "New Computer Modern Math", size: 10pt)

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
        align(left)[*#current-num#text(fill: black)[#current-title]*], align(right)[*#page-num*],
      )
      v(-0.5em)
      line(length: 100%, stroke: 0.5pt)
    },
    numbering: "1",
  )

  // Cấu hình văn bản toàn cục
  set text(font: "New Computer Modern", size: 11pt, lang: "vi")
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
  // ==========================================

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
      ],
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
#let cau(title: none, body) = math-box(title: title, prefix: "Bài", color: color-cau, bg: bg-cau, body)
#let vidu(title: none, body) = math-box(title: title, prefix: "Ví dụ", color: color-ex, bg: bg-ex, body)

#let chungminh(body) = block(spacing: 1.2em, width: 100%)[
  #set par(justify: true, leading: 1.4em) // Ép căn đều bên trong Chứng minh
  #text(fill: color-text, weight: "bold")[Chứng minh.] #body #h(1fr) $square$
]

#let loigiai(body) = block(spacing: 1.2em, width: 100%)[
  #set par(justify: true, leading: 1.4em) // Ép căn đều bên trong Lời giải
  #text(fill: color-text, weight: "bold")[Lời giải.] #body #h(1fr) $square$
]

#let baitap(num: "", body) = block(spacing: 1.2em, width: 100%)[
  #set par(justify: true, leading: 1.4em) // Ép căn đều bên trong Bài tập
  #text(fill: color-text, weight: "bold")[Bài tập #num.] #body
]

// ==========================================
// BẮT ĐẦU NỘI DUNG VĂN BẢN
// ==========================================


#show: template.with(
  title: "Giải Tích 3A",
  subtitle: "HCMUS",
  author: "Khương",
)


// Tạo Trang Bìa
#include "trang_bia_hcmus/bia_xac_suat.typ"

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

= Lý Thuyết
== Không gian định chuẩn,mêtric
=== Không gian định chuẩn
#dinhnghia[*(Không gian véc-tơ)*

  Trên $RR^n$, tập hợp bộ $n$ số thực có thứ tự $x=(x_1,x_2,dots,x_n) in RR^n, x_i in RR, forall i= in {1,dots ,n}$.

  Ta trang bị hai phép toán :

  *(i)* Phép cộng $(+)$ giữa hai véc-tơ $x=(x_1,x_2,dots,x_n)in RR^n$, $y=(y_1,y_2,dots,y_n) in RR^n$, do đó $x+y=(x_1+y_1,dots,x_n+y_n)in RR^n$.

  *(ii)* Phép nhân $(.)$ giữa một số thực $alpha in RR$ và một véc-tơ $x=(x_1,dots,x_n) in RR^n$, khi đó $alpha x =(alpha x_1,alpha x_2,dots,alpha x_n) in RR^n$.

  Với $(RR^n,+,dot )$ được trang bị như trên, ta có $8$ tính chất sau được thỏa mãn.

  Với mỗi $x,y,z in RR^n$ và $alpha,beta in RR$

  *(i)* x+y=y+x

  *(ii)* (x+y)+z=x+(y+z)

  *(iii)* Tồn tại véc-tơ không , $0=(0,0,dots,0)$

  *(iv)* Tồn tại véc-tơ đối của véc-tơ $x$, ký hiệu là $-x$, thỏa mãn $x+(-x)=(-x)+x=0$


  *(v)* $1dot x = x$

  *(vi)* $(alpha beta) x= alpha (beta x)$

  *(vii)* $alpha(x+y)=alpha x + alpha y$

  *(viii)* $(alpha + beta) x=alpha x + beta x$

]
#dinhnghia[
  *(Không gian định chuẩn)*

  Cho $E$ là một không gian véc-tơ. Một ánh xạ
  $
    norm(.): E -> RR_+
  $
  được gọi là một *(chuẩn)* trên $E$ nếu thỏa mãn ba tính chất sau :

  *(M1)* Phân biệt dương : $norm(x) >=0$, với mỗi $x in E$ và $norm(x)=0 <=> x=0$

  *(M2)* Chuẩn véc-tơ bội : $norm(alpha x)=abs(alpha)dot norm(x)$, với mỗi $x in E$ và $alpha in RR$.

  *(M3)* Bất đẳng thức tam giác : $norm(x+y) <= norm(x)+norm(y)$, với mỗi $x,y ,in E$.

  Khi này, ta nói $(E,norm(.))$ là một *không gian định chuẩn*.

]
#vidu[
  Chứng minh rằng $(RR,abs(.))$ là một không gian định chuẩn.
]
#chungminh[
  Ta thấy $RR$ là một không gian véc-tơ. Ta chứng minh ánh xạ $abs(.) RR -> RR_+$ là một chuẩn. Cụ thể, với tùy ý $x,y,alpha in RR$, có :

  *(M1)* Phân biệt dương : $abs(x)>=0$ và $abs(x)=0 <=> x=0$

  *(M2)* Chuẩn véc-tơ bội : $abs(alpha x)=abs(alpha)dot abs(x)$

  *(M3)* Bất đẳng thức tam giác : tam giác $abs(x+y) <= abs(x)+abs(y)$, Vậy ánh xạ $abs(.)$ là một chuẩn, do đó, $(R,abs(.))$ là không gian định chuẩn.

]
#vidu[
  Trong $RR^n$, chứng minh rằng các ánh xạ sau đây là một chuẩn.

  *(a)* $ norm(.)_2:
  RR^n & -> RR_+ \
     x & |-> norm(x)_2=norm((x_1,x_2,dots,x_n))=sqrt(x_1^2+x_2^2+dots+x_n^2) \ $

  *(b)* $ norm(.)_1:
  RR^n & -> RR_+ \
     x & |-> norm(x)_2= abs(x_1)+ abs(x_2)+dots + abs(x_n)=sum_(i=1)^n abs(x_i) $

  *(c)* $ norm(.)_infinity:
  RR^n & -> RR \
     x & |-> norm(x)_infinity = max(abs(x_i)), i=1,2,dots,n $
]
#chungminh[

  Xét tùy ý $x,y in RR^n$ và $alpha in RR$.

  *(a)*

  *(M1)*
  $norm(x)_2=sqrt(sum_(i=1)^n x_i^2)>=0$ và $norm(x)_2=0 <=> x_i=0,forall i =1,2,dots,n <=> x=0$.

  *(M2)* $norm(alpha x)=norm((alpha x_1,alpha x_2,dots,alpha x_n))=sqrt((alpha x_1)^2 +alpha(x_2)^2 + dots + (alpha x_n)^2)=sqrt(alpha^2(sum_(i=1)^n x_i^2))=abs(alpha) sqrt(sum_(i=1)^n x_i^2)=abs(alpha) norm(x)_2$

  *(M3)* Xét $norm(x+y)_2=norm((x_1+y_1,x_2+y_2,dots,x_n+y_n))=sqrt(sum_(i=1)^n (x_i+y_i)^2)$.

  Ta cần chứng minh $norm(x+y)_2 <= norm(x)_2 + norm(y)_2 <=> sqrt(sum_(i=1)^n (x_i+y_i)^2) <= sqrt(sum_(i=1)^n x_i^2) + sqrt(sum_(i=1)^n y_i^2) quad (1.1)$.

  Từ $(1.1)$, ta thấy
  $
    sum_(i=1)^n (x_i+y_i)^2 <= sum_(i=1)^n x_i^2 + sum_(i=1)^n y_i^2 + 2 sqrt(sum_(i=1)^n x_i^2) sqrt(sum_(i=1)^n y_i^2) quad (1.2)
  $

  Vì $sum_(i=1)^n (x_i+y_i)^2= sum_(i=1)^n (x_i^2+2x_i y_i + y_i^2)$ nên $(1.2)$ trở thành $sum_(i=1)^n x_i y_i <= sqrt(sum_(i=1)^n x_i^2) sqrt(sum_(i=1)^n y_i^2)$. Đúng theo bất đẳng thức Cauchy-Schwarz, vậy $norm(.)_2$ là một chuẩn và $(RR^n,norm(.)_2)$ là một không gian định chuẩn

]


#vidu[
  Cho $p in NN$, ta có
  $
    norm(.)_p : RR^n & |-> R \
                   x & |-> norm(x)_p=(sum_(i=1)^n abs(x_i)^p)^(1/p)
  $
]
#chungminh[
  Xét tùy ý $x,y in RR^n$ và $alpha in RR$

  *(M1)* Có $ norm(x)_p=(sum_(i=1)^n|x_i|^p)^(1/p) >=0 $ và $ norm(x)_p=0 <=> sum_(i=1)^n |x_i|^p=0 <=> |x_i|=0,forall i in {1,2,dots,n} <=> x=0 $

  *(M2)* Có $ norm(alpha x)_p=(sum_(i=1)^n abs(alpha x_i)^p)^(1/p)=(abs(alpha)^p sum_(i=1)^n abs(x_i)^p)^(1/p)=abs(alpha)(sum_(i=1)^n abs(x_i)^p)^(1/p)=abs(alpha) norm(x)_p $

  *(M3)* *Cách 1. Sử dụng bất đẳng thức Hölder.*

  Với $p=1$, bất đẳng thức suy ra trực tiếp từ bất đẳng thức tam giác. Xét $p>1$, đặt $q=p/(p-1)$, khi đó $1/p+1/q=1$.

  Theo bất đẳng thức tam giác và Hölder, ta có

  $
    ||x+y||_p^p & = sum_(i=1)^n |x_i+y_i|^p \
                & <= sum_(i=1)^n (|x_i|+|y_i|)|x_i+y_i|^(p-1) \
                & = sum_(i=1)^n |x_i||x_i+y_i|^(p-1)
                  + sum_(i=1)^n |y_i||x_i+y_i|^(p-1) \
                & <= (sum_(i=1)^n |x_i|^p)^(1/p)
                  (sum_(i=1)^n |x_i+y_i|^((p-1)q))^(1/q) \
                & quad + (sum_(i=1)^n |y_i|^p)^(1/p)
                  (sum_(i=1)^n |x_i+y_i|^((p-1)q))^(1/q).
  $

  Vì $(p-1)q=p$ nên

  $
    ||x+y||_p^p & <= (||x||_p+||y||_p)
                  (sum_(i=1)^n |x_i+y_i|^p)^(1/q) \
                & = (||x||_p+||y||_p)||x+y||_p^(p-1).
  $

  Nếu $||x+y||_p=0$ thì bất đẳng thức hiển nhiên đúng. Ngược lại, chia hai vế cho $||x+y||_p^(p-1)$, suy ra

  $
    ||x+y||_p <= ||x||_p + ||y||_p.
  $

  *Cách 2. Sử dụng bất đẳng thức Young.*

  Với $p=1$, bất đẳng thức hiển nhiên đúng. Xét $p>1$, ta sử dụng bất đẳng thức Young:

  $
    a b <= a^p/p + (p-1)/p b^(p/(p-1)),
    quad a,b >= 0.
  $

  Đặt $A=||x||_p$, $B=||y||_p$, $S=||x+y||_p$. Nếu một trong ba số bằng $0$ thì bất đẳng thức hiển nhiên đúng. Giả sử $A,B,S>0$.

  Chọn $a=|x_i|/A$ và $b=(|x_i+y_i|/S)^(p-1)$. Áp dụng bất đẳng thức Young, ta được

  $
    (|x_i| |x_i+y_i|^(p-1))/(A S^(p-1))
    <= |x_i|^p/(p A^p)
    + (p-1)/p (|x_i+y_i|^p)/S^p.
  $

  Lấy tổng hai vế theo $i$ từ $1$ đến $n$, suy ra

  $
    (sum_(i=1)^n |x_i||x_i+y_i|^(p-1))/(A S^(p-1)) & <= 1/(p A^p) sum_(i=1)^n |x_i|^p \
                                                   & quad + (p-1)/(p S^p) sum_(i=1)^n |x_i+y_i|^p \
                                                   & = 1/p + (p-1)/p = 1.
  $

  Do đó

  $
    sum_(i=1)^n |x_i||x_i+y_i|^(p-1) <= A S^(p-1).
  $

  Tương tự, ta có

  $
    sum_(i=1)^n |y_i||x_i+y_i|^(p-1) <= B S^(p-1).
  $

  Suy ra

  $
    S^p & = sum_(i=1)^n |x_i+y_i|^p \
        & <= sum_(i=1)^n (|x_i|+|y_i|)|x_i+y_i|^(p-1) \
        & <= (A+B)S^(p-1).
  $

  Vì $S>0$, chia hai vế cho $S^(p-1)$, ta được

  $
    S <= A+B
    <=> ||x+y||_p <= ||x||_p+||y||_p.
  $

  Vậy bất đẳng thức Minkowski đúng với mọi $p>=1$.
]
#menhde[
  *(Bất đẳng thức tam giác ngược)*

  Cho $(E,norm(.))$ là một không gian định chuẩn. Khi đó,với mỗi $x,y in E$ $abs(norm(x)- norm(y)) <=norm(x-y) quad (1.3)$]
#chungminh[

  Có $(1.3)$ tương đương với $-norm(x-y)<= norm(x)- norm(y) <= norm(x-y) quad (1.4)$

  Vì $norm(.)$ là một chuẩn nên theo $(N_3)$ ta có $u,v in E$ thì
  $
    norm(u+v) <= norm(u)+norm(v)
  $
  Bất đẳng thức đầu tiên trong $(1.4)$ có thể viết lại như sau :
  $
    norm(y) <= norm(x)+norm(x-y)=norm(x)+norm(y-x)
  $
  Đây chính là bất đẳng thức $(1.5)$ với $u=x$ và $v=y-x$ theo đó $u+v=y$

  Tương tự, bất đẳng thức còn lại trong $(1.4)$ tương đương với $ norm(x)<=norm(x-y)+norm(y) $
  Đây chính là $(1.5)$ với $u=x-y$ và $v=y$.
]
#menhde[
  Cho $n in NN$ và $x in RR^n$.

  *(a)* $norm(x)_infinity <= norm(x)_2<=sqrt(n) norm(x)_infinity$.

  *(b)* $1/(sqrt(n)) norm(x)_1 <= norm(x)_2<= norm(x)_1$
]
#chungminh[

  *(a)* Nhắc lại, với
  $ x=(x_1,x_2,dots,x_n)in RR^n $, $ norm(x)_2=sqrt(sum_(i=1)^n x_i^2) $ và $ norm(x)_infinity=max_(i=1,2,dots n) abs(x_i) $
  Ta có $j in {1,2,dots,n}$ sao cho $norm(x)_infinity=abs(x_j)$. Khi đó, $ norm(x)_infinity=abs(x_j)=sqrt(x_j^2)<=sqrt(sum_(i=1)^n x_i^2)=norm(x)_infinity $
  Mặt khác, $ norm(x)_2=sqrt(sum_(i=1)^n x_i^2)<= sqrt(sum_(i=1)^n x_j^2)=sqrt(x_j^2)sqrt(sum_(i=1)^n 1)=sqrt(n) norm(x)_infinity $

  *(b)* Tương tự $norm(x)_1=sum_(i=1)^n abs(x_i)$, ta có $             1/(sqrt(n))norm(x) & <=norm(x)_2 \
                   <=> norm(x)_1 & <= sqrt(n) norm(x)_2 \
  <=> sum_(i=1)^n abs(1 dot x_i) & <=sqrt(sum_(i=1)^n 1^2) dot sqrt(sum_(i=1)^n x_i^2). $
  Mà theo bất đẳng thức Cauchy-Schwarz thì bất đẳng thức trên đúng.

  Cuối cùng $ norm(x)_2 <= norm(x)_1 <=> sqrt(sum_(i=1)^n x_i^2)<= sum_(i=1)^n abs(x_i) $
  Bình phương hai vế, cho ta
  $
    sum_(i=1)^n x_i^2 <= (sum_(i=1)^n abs(x_i))^2 quad (1.7)
  $
  Ta thấy
  $
    (sum_(i=1)^n abs(x_i))^2=sum_(i=1)^n abs(x_i)^2 + 2sum_(i=1)^n sum_(j=1,j!=i)^n abs(x_i) abs(x_j)
  $

  Nghĩa là $(1.7)$ tương đương với $ 0<=2sum_(i=1)^n sum_(j=1,j!=i)^n abs(x_i) abs(x_j) $
  luôn đúng, vậy ta có điều phải chứng minh.
]
#dinhnghia[
  *(Chuẩn tương đương)* Cho $E$ là một không gian véc-tơ $E$. Giả sử $norm(.)_k$ và $norm(.)_l$ là hai chuẩn trên E. Ta nói $norm(.)_k$ và $norm(.)_l$ là hai chuẩn tương đương khi và chỉ khi tồn tại $M>1$ sao cho
  $
    1/M norm(x)_k<= norm(x)_l<=M norm(x),forall x in E
  $
]
#vidu[
  Theo mệnh đề $1.7$, trong $RR^n$ ta có
  $
    norm(x)_infinity<=norm(x)_2<=sqrt(n) norm(x)_infinity
  $
  Chọn $M=sqrt(n)>1$ thì ta có
  $
    1/sqrt(n) norm(x)_infinity <= norm(x)_infinity <= norm(x)_2<=sqrt(n) norm(x)_infinity
  $
  Vậy hai chuẩn $norm(.)_2$ và $norm(.)_infinity$ tương đương trên $RR^n$.

  *(b)* Tương tự, ta có chuẩn $norm(.)_1$ và $norm(.)_2$ là tương đương trên $RR^n$. Theo mệnh đề $(1.7)$, trong $RR^n$, ta có
  $
    1/sqrt(n) norm(x)_1<=norm(x)_2<=norm(x)_1<=sqrt(n) norm(x)_1
  $
  Chọn $M=sqrt(n)>=1$, ta có hai chuẩn $norm(.)_1$ và $norm(.)_2$ là tương đương trên $RR^n$.
]


#dinhnghia[
  Cho $E$ là một tập hợp khác rỗng. Một metric trên $E$ là một ánh xạ
  $
    delta: E times E -> RR
  $
  thỏa các tính chất

  *(i)* Phân biệt dương :$delta(x, y) >=0 ,delta(x, y)=0 <=> x=y , forall x,y in E$

  *(ii)* Đối xứng : $delta(x, y)=delta(y, x)$

  *(iii)* Bất đẳng thức tam giác: $delta(x, y) <= delta(x, z)+delta(z, y), forall x,y,z in E$
]

#dinhnghia[
  Một không gian metric là một cặp $(E,delta)$, trong đó $E$ là tập hợp khác rỗng và $delta$ là một metric trên $E$.
]
#dinhnghia[


]

== Quả Cầu

#dinhnghia[
  Cho $(E,d)$ là một không gian metric. Quả cầu mở tâm $a in E$ với bán kính $r>0$. $cal(B)(a,r)={x in E | d(x,a)< r}$. Cho $(x_n)$ là một dãy trong $E$, khi đó $(forall n)(x_n in E)$. Ta nói $x_n limits(stretch(arrow.r))_(n -> oo)^d x<=>(forall epsilon>0)(exists N(epsilon) in NN)$ sao cho $(forall n in NN)(n>= N(epsilon)=> d(x_n,x)<epsilon)$.
]
#menhde[
  Cho $(x_n)$ là một dãy trong $E$ và $x in E$. Ta có $ x_n limits(stretch(arrow.r))_(n -> oo)^d x <=> lim_(n -> infinity) d(x_n,x)=0 $
]
#chungminh[
  Với mỗi $n in NN$, ta đặt $z_n=d(x_n,x)>=0$.

  *(=>)* Giả sử $x_n limits(stretch(arrow.r))_(n -> oo)^d x$. Ta cần chứng minh $lim_(n -> infinity) z_n=0$. Cho trước $epsilon>0$, tìm $M(epsilon) in NN$ sao cho với $n in NN$ cho trước, nếu $n>= N(epsilon)$ thì $z_n=d(x_n,x)<epsilon$. Từ giả thiết, với bất kỳ $epsilon'>0$ ta đều có $N'(epsilon') in NN$ sao cho với bất kỳ $n in NN$, nếu $n >=N'(epsilon')$ thì ta luôn có $d(x_n,x)<epsilon'$. Do đó, xét $epsilon'=epsilon$ và chọn $N(epsilon)=N'(epsilon')$. Ta có điều phải chứng minh.

  *(<=)* Chiều ngược lại tương tự, chọn $N(epsilon)=N'(epsilon')$ và xét $epsilon=epsilon'$.
]
#vidu[
  Cho $E=C([0,1])$ tập hợp các hàm số $f : [0,1] -> RR$ liên tục. Cho hai metric.
  $
             d_1(f,g) & =integral_0^1|f(t)-g(t)| dif t \
    d_(infinity)(f,g) & =sup_(t in [0,1]) |f(t)-g(t)|.
  $
  Cho dãy $(f_n)$ được định nghĩa, với mỗi $n in NN$, $f_n(t)=t^n, t in [0,1]$ và $f : [0,1] -> RR$ thỏa $f(t)=0, t in [0,1]$.
]
#chungminh[

  *a)* Dãy $(f_n)$ hội tụ về $f$ khi $n-> infinity$ trong không gian metric $(E,d_1)$. Ta chứng minh $lim_(n-> infinity)d_1(f_n, f)=0$. Thật vậy, có $ d_1(f_n,f)=integral_0^1 |f_(n) (t)-f(t)| dif t & =integral_0^1 |t^n| dif t = integral_0^1 t^n dif t= 1/ (n+1) $
  Suy ra, $lim_(n -> infinity) d_1(f_n,f)=0$.

  *b)* Ta chứng minh $lim_(n -> infinity) d_(infinity) (f_(n)(t)-f(t))!=0$, thật vậy ta có $d_(infinity) (f_(n)(t)-f(t))= sup_(0<=t<=1) |t^n|$. Với $0<=t<=1$ thì $0<=t^n<=1$, do đó $sup_(0<=t<=1) t^n=1$ nên $lim_(n -> infinity) d_(infinity) (f_(n)-f) !=0$. Do ta chọn $t=1$, thì ta có $sup$


]

#dinhly[
  Giới hạn nếu có của dãy trong $(E,d)$ là duy nhất.
]
#chungminh[
  Đặt $x_n limits(stretch(arrow.r))_(n -> oo)^d x=a$ và $x_n limits(stretch(arrow.r))_(n -> oo)^d x=b$, ta chứng minh $a=b$. Giả sử $a != b$, khi đó $delta(a, b) >0$. Từ $x_n limits(stretch(arrow.r))_(n -> oo)^d x =a$, ta có với mỗi $epsilon_a >0$, ta đều có $N(epsilon_a) in NN$ sao cho $delta(x_n, a)<epsilon$, tương tự ta có với mỗi $epsilon_b>0$, đều có $N(epsilon_b) in NN$ sao cho $d(x_n,b)<epsilon_b$. Nếu xét $epsilon_a=epsilon_b$ và với $n>=max{N(epsilon_a),N(epsilon_b)}$ thì ta luôn có $d(x_n,a)< epsilon$ và $d(x_n,b) <epsilon$, khi đó xét $d(a,b)<=d(x_n,a) + d(x_n,b) < 2 epsilon$. Do đó, nếu xét $epsilon= 1/3 d(a,b)$ thì ta có điều vô lý. Vậy $a=b$.
]
#dinhnghia[
  Cho $(E,d)$ là một không gian metric và $A subset E$. Khi đó,
  - $a$ là điểm trong của $A$, nếu $exists r>0 : B(a,r) subset A$.
  - A là tập mở trong $(E,d)$, nếu mọi điểm của $A$ đều là điểm trong của $A$.
  $
    forall x in A, exists r>0:B(x,r) subset A.
  $
]
#vidu[
  Cho $(RR, d)$ là không gian mêtric với
  $d(x,y) = sqrt(abs(x-y))$, $forall x,y in RR$.

  a) Chứng minh $A = (0,1)$ là một tập mở trong $(RR, d)$.

  b) Cho $A = [0,1]$. Chứng minh: $a = 0$ không là điểm trong của $A$.
]
#chungminh[
  *a)* Lấy tùy ý $x in A$, tìm $r_x>0$ sao cho $B(x,r) subset A$. Khi đó, lấy bất kỳ $y in B(x,r)$, ta có $sqrt(abs(y-x))<r$, suy ra $ x-r^2<y<x+r^2. $
  Do đó, để $y in A$, thì $ (x-r^2,x+r^2) subset (0,1) $ Khi đó, $ cases(0<x-r^2, 1>x+r^2) => cases(r^2<x, r^2<1-x) $
  Do đó, chọn $r=sqrt(min{x,1-x})$. Thì $A=(0,1)$ là một tập mở trong $(RR,d)$.

  *b)* Cho $A=[0,1]$, chứng minh $a=0$ không là điểm trong của $A$. Thật vậy, cho trước $r >0$, ta chứng minh $B(a,r) subset.not A$. Hay chứng minh $exists x in B(a,r)$ thì $x in.not A$. Thật vậy, có $x in B(a,r)$ khi đó $a-r^2<x<a+r^2 <=> -r^2 <x<r^2$. Vì $-r^2<0$, nên ta chọn $x=-r^2/2$, thì $x in.not A$.
]
#dinhnghia[
  Cho $(E, delta)$ là không gian mêtric và $A subset E$. Khi đó

  - $a$ là *điểm dính* của $A$ nếu:
    $forall r > 0, B(a,r) inter A != emptyset$.

  - $A$ là *tập đóng* trong $(E, delta)$ nếu mọi điểm dính của $A$ đều thuộc $A$.

  - $A$ là *tập bị chặn* nếu nó chứa trong một quả cầu, nghĩa là:

    $exists a in E, exists r > 0: A subset B(a,r).$
]

#vidu[
  Cho $(RR, delta)$ là một không gian mêtric với
  $delta(x, y) = abs(x-y)$, $forall x,y in RR$ và $A = [1,2)$.
  Chứng minh rằng

  a) $a = 1$ là điểm dính của $A$.

  b) $a = 2$ là điểm dính của $A$.
]
#chungminh[
  *a)* Ta chứng minh, $forall r >0, B(a,r) inter A!= emptyset$. Thật vậy, cho trước $r>0$, ta chứng minh $B(a,r) inter A!= emptyset$. Nếu với tùy ý $x in B(a,r)$ , ta đều có $|x-1|< r <=> 1-r <x<1+r$ và với $y in A$, thì $1<=y<2$, do đó ta chọn $z in [1,min{1+r,2}]$. Thì $z in B(a,r) inter A$.

  *b)* Cho trước $r>0$, ta chứng minh $B(2,r) inter A !=emptyset$. Thật vậy, nếu $y in B(2,r)$ thì $|y-2|<r <=> 2-r<y<2+r$ và $z in A$, thì $1<=z<2$. Do đó, chọn $x in (min{2-x,1},2]$. Ta có điều phải chứng minh.
]
== Dãy Cauchy - Không gian metric đầy đủ
#dinhnghia[
  Cho $(E,d)$ là không gian metric và $(x_n)$ là một dãy trong $E$.

  *a)* Dãy $(x_n)$ là bị chặn khi và chỉ khi $ exists (a,r) exists E times RR_(t t)(forall n in NN)(x_n in cal(B(a,r))) $.

  *b)* Dãy $(x_n)$ là *dãy Cauchy* khi và chỉ khi
  $
    (forall epsilon >0)(exists NN(epsilon) in NN) : (forall m,n in NN)(m,n>=N(epsilon)=> d(x_m,x_n)<epsilon
  $
]
#menhde[
  Cho $(E,d)$ là một không gian metric.

  *a)* Dãy Cauchy thì bị chặn.

  *b)* Dãy hội tụ thì là dãy Cauchy.
]
#chungminh[
  *a)*
  Ta cần tìm tâm $a in E$ và bán kính $r>0$ sao cho với $n in NN$ cho trước, $d(x_n,a)<epsilon$.

  Ứng với mỗi $epsilon>0$, ta luôn có $N(epsilon) in NN$ sao cho với $m,p in NN$, nếu $m,p>=N(epsilon)$ thì ta luôn có $d(x_m,x p)<epsilon$.

  Xét $epsilon=1$, ta có $N(1) in NN$ sao cho $forall n in NN$, nếu $m>=N(1)$ thì $d(x_m,x_(N(1)))<1$.
  Suy ra, với mọi $n in NN$, nếu $n>=1 N(1)$ thì $d(x_n,0) <= d(x_n,x_(N(1)))+d(x_(N(1)),0)<1+d(x_(N(1)),0)$. Chọn $r=max{1+d(x_(N(1)),0),d(x_1,0),...,d(x_(N(1)-1),0}$. Khi đó, với mọi $n in NN$, ta luôn có $d(x_n,0)<r$ hay $x_n in B(0,r)$.


  *b)* Chứng minh dãy hội tụ là dãy Cauchy. Dễ dàng chứng minh được.
]
#dinhnghia[

  *Không gian metric $(E,d)$ *là không gian metric *đầy đủ *nếu mọi dãy *Cauchy* trong $(E,d)$ đều là dãy hội tụ.
]
#dinhnghia[

  *Không gian Bannach* Cho $(E,||.||)$ là một không gain định chuẩn và $d(x,y)=||x-y||$, với mỗi $x,y in E$ là một metric trên $E$.Khi đó, $(E,||.||)$ là một không gian định chuẩn đầy đủ, hay không gian Bannach.
]
#vidu[
  Cho $E=RR$ và $d(x,y)=abs(e^x-e^y)$ với mỗi $x,y in EE$.

  *a)* Dãy $x_n=-n$ là dãy Cauchy.

  *b)* Dãy $(x_n)$ không hội tụ.
]
#chungminh[

  *a)* Cho trước $epsilon>0$, tìm $N(epsilon) in NN$, sao cho với $m,n in NN$ cho trước, nếu $m,n>=N(epsilon)$ thì cần $abs(e^(-m)-e^(-n))<epsilon$. Thật vậy, có $abs(e^(-m)-e^(-n))<=e^(-m)+e^(-n)$. Khi đó, với $m,n>=N(epsilon)$ thì $e^(-m)+e^(-n)<=2 e^(-N(epsilon))$. Để đảm bảo điều trên $<epsilon$ thì ta cần $e^(-N(epsilon))<epsilon/2$. Nên, chọn $N(epsilon)=[ln(epsilon/2)]+1$.

  *b)* Giả sử $(x_n)$ là dãy hội tụ về $a$ trong $RR$. Khi đó
  $
    lim_(k->infinity) e^(-k) -e^(-a)=0<=>e^(-a)=0 quad "Vô lý"
  $
  Vậy, $(x_n)$ không hội tụ trong $RR$.



]
#dinhly[

  Không metric $(R,d_(t t))$ với metric $d_(t t)(x,y)=abs(x-y)$ là một không gian metric đầy đủ.
]
#chungminh[
  Ta nhắc lại kết quả sau, mọi dãy bị chặn trong $RR$, đều có dãy con hội tụ. Lấy $(x_n) in RR$, sao cho $(x_n)$ là dãy Cauchy. Ta chứng minh $(x_n)$ hội tụ, thật vậy vì $(x_n)$ là dãy Cauchy nên $(x_n)$ bị chặn. Mặt khác, theo định lý Bolzano-Weirnstrass thì mọi dãy bị chặn trong $RR$ đều có dãy con hội tụ nên do đó có dãy con $x_(n_k) -> x$ trong $RR$. Vậy ta chứng minh $(x_n) -> x$.

  Vì $(x_n)$ là dãy Cauchy, nên với mỗi $epsilon>0$, đều tìm được $N(epsilon in NN)$ sao cho với mỗi $m,n in NN$, nếu $m,n>=N(epsilon)$ thì có $d(x_m,x_n)<epsilon$.

  Mặt khác, do $(x_(n_k)->x)$, nên với mỗi $epsilon_1>0$, luôn có $K(epsilon_1) in NN$ sao cho với mỗi $k in NN$, nếu $k>=K(epsilon_1)$ thì $d(x_(n_k),x)<epsilon_1$.

  Vậy, cho trước $epsilon_2>)$, tìm $M(epsilon_2)in NN$, sao cho với $n in NN$ cho trước, nếu $n>=M(epsilon_2)$ thì cần $d(x_n,x)<epsilon_2$.

  Có, $d(x_n,x)=<=d(x_n,x_(n_k))+d(x_(n_k),x)<epsilon+epsilon_1$.
  Nên, nếu xét $epsilon=epsilon_1=epsilon_2/2$, và chọn $M(epsilon_2)=max{K(epsilon_1),N(epsilon)}$ Thì ta có điều phải chứng minh.

]
#vidu[

  Cho $(RR^2,d)$ là một không gian metric với
  $
    d(x,y)=abs(x_1-y_1) +abs(x_2-y_2), quad forall x=(x_1,x_2),y=(y_1,y_2)
  $
]
#chungminh[

  Ta chứng minh $(RR^2,d)$ là không gian metric đầy đủ. Lấy $(u_n) in RR^2$ sao cho $(u_n)$ là dãy Cauchy. Ta chứng minh $(u_n)$ là dãy hội tụ. Hay tìm $u in RR^2$ sao cho $u_n -> u$.

  Vì $(u_n)$ là dãy Cauchy, nên $forall epsilon >0,exists N(epsilon) in NN,forall n,m in NN :
  m,n>=N(epsilon) => d(u_n,u_m)<epsilon$.

  Có $d(u_n,u_m)=abs(abs(x_n-x_m)+abs(y_n-y_m))=abs(x_n-x_m)+abs(y_n-y_m)<epsilon$. Nên suy ra, $forall epsilon>0,exists N(epsilon) in NN$ sao cho $forall m,n in NN : m,n>=N(epsilon)$ thì $abs(x_m-x_n)<epsilon$ và $abs(y_n-y_m)<epsilon$.Nên $(x_n)$ và $(y_n)$ là các dãy Cauchy trong $(R,d_(t t))$. Vì $(R,d_(t t))$ là không gian metric đầy đủ nên $exists x_1 in RR$ và $y_1 in RR$ sao cho $(x_n -> x_1)$ và $(y_n -> y_1)$. Do đó, nếu chọn $x=(x_1,y_1) in RR^2$, thì có
  $
    lim_(n->infinity) d(u_n,u)=lim_(n->infinity) abs(x_n-x_1)+abs(y_n-y_1)=0
  $
]
== Không gian Metric Compact

#dinhnghia[
  Cho $(E, delta)$ là một không gian mêtríc. Khi đó

  (i) $E$ *compắc* nếu mọi dãy $(u_n)_(n in NN)$ trong $E$ chứa
  một dãy con $(u_(n_k))_(k in NN)$ hội tụ về $u in E$.

  (ii) Cho $D subset E$, $D != emptyset$. $D$ được gọi là
  *tập compắc* nếu mọi dãy $(u_n)_(n in NN)$ trong $D$
  đều chứa một dãy con $(u_(n_k))_(k in NN)$
  hội tụ về $u in E$.
]

#menhde[

  Cho $A!=emptyset subset.eq E$ và $(E,d)$ là một không gian mê-tríc. Nếu tập A là tập compắc thì $A$ là tập đóng và bị chặn.
]
#chungminh[

  - Chứng minh $A$ là tập đóng :
  Cho $x$ là một điểm dính của $A$, ta chứng minh $x in A$.Vì $x$ là điểm dính của $A$, nên có $(x_n) subset A$, sao cho $(x_n -> x)$. Mặt khác, vì $A$ là tập compắc nên ứng với dãy $(x_n)$ ở trên, tìm được dãy con $x_(n_k) -> y in A$. Mà $(x_n -> x)$, hơn nữa giới hạn là duy nhất nên phải có $y=x$ mà $y in A$, nên $x in A$. Vậy $x in A$, nên $A$ là tập đóng.

  - Chứng minh A bị chặn : $<=> (exists(a, r) in E times RR_(t t))(A subset.eq B(a,r))$.
  Giả sử $A$ không bị chặn,khi đó
  $
    forall a in E, forall r>0, A subset.not B(a,r).
  $
  Có nghĩa là, có $x in A and x in.not cal(B(a,r))$. Khi đó, với mỗi $a in E$ và $r>0$, ta có $x_(a,r) in A$ mà $x_(a,r) in.not B(a,r)$. Có nghĩa là $d(x_(a,r),a)>=r$. Cố định $a in E$, khi đó ứng với mỗi $r=n in NN$, ta có $y_n=x_(a,n) in A$ mà $d(y_n,a) >=RR$.


]

#pagebreak()
= Bài Tập
== Tuần 1



*Bài tập 1.1.* Cho $(E, norm(dot))$ là một không gian định chuẩn. Ta định nghĩa

$
  d: E times E -> RR \
  (x,y) ↦ norm(x-y).
$

Chứng minh rằng $d$ xác định một metric trên $E$.
#loigiai[

  *(i)* Có $norm(x-y)>=0$, do đó $d(x,y)>=0$ và $d(x,y)=0 <=> norm(x-y)=0 <=> x-y=0 <=> x=y$.

  *(ii)* Có $d(x,y)=norm(x-y)=norm(y-x)=d(y,x)$.

  *(iii)* Lấy tùy ý $x,y,z in E$, vì $norm(.)$ là một chuẩn trên $E$, do đó $norm(x-y)<=norm(x-z)+norm(y-z)$ hay $d(x,y)<=d(x,z)+d(y,z)$.

  Từ (i),(ii),(iii) suy ra $d$ là một metric trên E.
]
*Bài tập 1.2.* Cho $(E,d)$ là một không gian metric. Chứng minh rằng

$ abs(d(x,z)-d(y,z)) <= d(x,y) $

với mọi $x,y,z in E$.
#loigiai[

  Với bất kỳ $x,y,z in E$, ta đều có $d(x,z)<=d(x,y)+d(y,z) <=> d(x,z)-d(y,z)<=d(x,y)$.

  Tương tự, ta cũng có $d(y,z)<=d(x,z)+d(x,y) <=> d(y,z)-d(x,z)<=d(x,y) <=> d(x,z)-d(y,z)>=-d(x,y)$, suy ra
  $
    abs(d(x,z)-d(y,z))<=d(x,y).
  $
]
*Bài tập 1.3.* Cho $E$ là tập hợp khác rỗng và $delta: E times E -> RR$ thỏa các tính chất

(i) $delta(x, y) >= 0 quad forall x,y in E,$

$delta(x, y)=0 <=> x=y,$

(ii) $delta(x, y) <= delta(x, z) + delta(y, z) quad forall x,y,z in E.$

Chứng minh rằng $delta$ là một metric trên $E$.
#loigiai[

  Từ (ii), chọn $z=x$, thì $delta(x, y)<=delta(y, x)$.

  Có $delta(y, x)<=delta(y, z)+delta(x, z)$, chọn $z=y$ thì $delta(y, x)<=delta(x, y)$ do đó $delta(x, y)=delta(y, x)$, kết hợp với (i),(ii), suy ra $delta$ là một metric trên E.
]
*Bài tập 1.4.* Trên $RR$, ta định nghĩa

$ d(x,y) = frac(abs(x-y), (1+abs(x))(1+abs(y))), quad x,y in RR. $

Chứng minh rằng $d$ xác định một metric trên $RR$.
#loigiai[

  *(i)* Có $d(x,y)>=0$ và $d(x,y)=0 <=> abs(x-y)=0 <=> x-y =0 <=> x=y$.

  *(ii)* Có $d(x,y)=abs(x-y)/((1+abs(x))(1+abs(y)))=abs(y-x)/((1+abs(y))(1+abs(x)))=d(y,x)$.

  *(iii)* Cần chứng minh $d(x,y)<= d(x,z)+d(y,z), forall x,y,z in RR$, điều cần chứng minh tương đương
  $ abs(x-y)/((1+abs(x))(1+abs(y)))<=abs(x-z)/((1+abs(x))(1+abs(z)))+abs(z-y)/((1+abs(y))(1+abs(z))). $ Suy ra,
  $
    abs(x-y)(1+abs(z))<=abs(x-z)(1+abs(y))+abs(y-z)(1+abs(x)).
  $
  Tương đương với,
  $
    abs(x-y)+abs(x-y) abs(z)<=abs(x-z)+abs(x-z)abs(y)+abs(z-y)+abs(z-y)abs(x). quad (1)
  $
  Kiểm tra $(x-y)z=(x-z)y+(z-y)x$, do đó $abs((x-y)z)=abs((x-z)y+(z-y)x)<=abs(x-z)y+abs(z-y)x$, hơn nữa , $abs(x-y)<=abs(x-z)+abs(z-y)$, cộng $2$ biểu thức trên, ta được $(1)$.Vậy từ (i),(ii),(iii) ta có $d$ là một metric trên $RR$.
]
*Bài tập 1.5.* Chứng minh các ánh xạ sau đây là các chuẩn trên $RR^2$.

a) $norm((x,y)) = max(abs(x), abs(y)) + frac(1, 2) abs(x+y).$

b) $norm((x,y)) = max(abs(x+y), abs(x-y)).$

c) $norm((x,y)) = sqrt(3x^2 + 2y^2 + 2x y).$
#loigiai[


  *a)*

  Đặt $N(u) = max(abs(x), abs(y)) + 1/2 abs(x+y)$, với $u=(x,y) in RR^2$.

  *(i)*

  Với bất kỳ $u=(x,y) in RR^2$, ta có $N(u) >= 0$. Hơn nữa,
  $
    N(u)=0 & <=> max(abs(x), abs(y)) + 1/2 abs(x+y)=0 \
           & <=> x=y=0 \
           & <=> u=0.
  $

  *(ii)*

  Với mọi $alpha in RR$ và $u=(x,y) in RR^2$, ta có
  $
    N(alpha u) & = max(abs(alpha x), abs(alpha y)) + 1/2 abs(alpha x+alpha y) \
               & = abs(alpha) max(abs(x), abs(y)) + abs(alpha)/2 abs(x+y) \
               & = abs(alpha) N(u).
  $

  *(iii)*
  Cho $u=(x_1,y_1)$ và $v=(x_2,y_2)$ thuộc $RR^2$.

  Theo bất đẳng thức tam giác của giá trị tuyệt đối,
  $
    abs(x_1+x_2) & <= abs(x_1)+abs(x_2), \
    abs(y_1+y_2) & <= abs(y_1)+abs(y_2).
  $

  Suy ra
  $
    max(abs(x_1+x_2), abs(y_1+y_2)) & <= max(abs(x_1), abs(y_1)) \
                                    & quad + max(abs(x_2), abs(y_2)).
  $

  Mặt khác,
  $
    abs((x_1+y_1)+(x_2+y_2))
    <= abs(x_1+y_1)+abs(x_2+y_2).
  $

  Cộng hai bất đẳng thức tương ứng, ta được
  $
    N(u+v) <= N(u)+N(v).
  $

  Vậy $N$ là một chuẩn trên $RR^2$.

  *b)* Đặt $N(u)=max(abs(x+y), abs(x-y))$, với $u=(x,y) in RR^2$.

  Trước hết, ta chứng minh
  $
    max(abs(x+y), abs(x-y)) = abs(x)+abs(y).
  $

  Thật vậy, xét hai trường hợp:

  - Nếu $x y >= 0$ thì $abs(x+y)=abs(x)+abs(y)$.
  - Nếu $x y < 0$ thì $abs(x-y)=abs(x)+abs(y)$.

  Đồng thời, theo bất đẳng thức tam giác,
  $
    abs(x+y) & <= abs(x)+abs(y), \
    abs(x-y) & <= abs(x)+abs(y).
  $

  Do đó,
  $
    N(u)=abs(x)+abs(y).
  $

  Đây chính là chuẩn $l_1$ trên $RR^2$.

  Cụ thể, ta có:

  *(i)*

  $
    N(u)=abs(x)+abs(y) >= 0,
  $
  và $N(u)=0 <=> x=y=0 <=> u=0$.

  *(ii)*

  $
    N(alpha u) & = abs(alpha x)+abs(alpha y) \
               & = abs(alpha)(abs(x)+abs(y)) \
               & = abs(alpha)N(u).
  $

  *(iii)*

  Với $u=(x_1,y_1)$, $v=(x_2,y_2)$, ta có
  $
    N(u+v) & = abs(x_1+x_2)+abs(y_1+y_2) \
           & <= abs(x_1)+abs(x_2)+abs(y_1)+abs(y_2) \
           & = N(u)+N(v).
  $

  Vậy $N$ là một chuẩn trên $RR^2$.

  *c)* Đặt $N(u)=sqrt(3x^2+2y^2+2x y)$, với $u=(x,y) in RR^2$.

  Nhận xét rằng
  $
    3x^2+2y^2+2x y = 2x^2+(x+y)^2+y^2.
  $

  Xét ánh xạ tuyến tính $T: RR^2 -> RR^3$ xác định bởi
  $
    T(x,y)=(sqrt(2)x, x+y, y).
  $

  Khi đó
  $
    N(u) = norm(T(u))_2,
  $
  trong đó $norm(dot)_2$ là chuẩn Euclid trên $RR^3$.

  *(i)*

  Vì
  $
    N(u)=sqrt(2x^2+(x+y)^2+y^2) >= 0,
  $
  nên
  $
    N(u)=0 & <=> 2x^2+(x+y)^2+y^2=0 \
           & <=> x=y=0 \
           & <=> u=0.
  $

  *(ii)*

  Vì $T$ tuyến tính nên với mọi $alpha in RR$,
  $
    N(alpha u) & = norm(T(alpha u))_2 \
               & = norm(alpha T(u))_2 \
               & = abs(alpha) norm(T(u))_2 \
               & = abs(alpha)N(u).
  $

  *(iii)*

  Với mọi $u,v in RR^2$, do tính tuyến tính của $T$ và bất đẳng thức tam giác đối với chuẩn Euclid, ta có
  $
    N(u+v) & = norm(T(u+v))_2 \
           & = norm(T(u)+T(v))_2 \
           & <= norm(T(u))_2+norm(T(v))_2 \
           & = N(u)+N(v).
  $

  Vậy $N$ là một chuẩn trên $RR^2$.
]
*Bài tập 1.6.* Cho $A$ là một ma trận thực vuông cấp $n$ đối xứng và xác định dương. Chứng minh rằng ánh xạ

$ norm(x) := sqrt(x A x^T), quad x=(x_1,x_2, ..., x_n) in RR^n, $

xác định một chuẩn trên $RR^n$.
#loigiai[
  Vì $A$ là ma trận đối xứng và xác định dương nên
  $
    A^T = A, quad x A x^T > 0, quad
    forall x in RR^n, x != 0.
  $

  Ta chứng minh ánh xạ $norm(x) = sqrt(x A x^T)$ thỏa mãn ba tiên đề của chuẩn.

  *(i)*

  Với mọi $x in RR^n$, do $A$ xác định dương nên
  $
    norm(x) = sqrt(x A x^T) >= 0.
  $

  Hơn nữa,
  $
    norm(x) = 0 & <=> x A x^T = 0 \
                & <=> x = 0.
  $

  *(ii)*

  Với mọi $alpha in RR$ và $x in RR^n$, ta có
  $
    norm(alpha x) & = sqrt((alpha x) A (alpha x)^T) \
                  & = sqrt(alpha^2 x A x^T) \
                  & = abs(alpha) sqrt(x A x^T) \
                  & = abs(alpha) norm(x).
  $

  *(iii)*

  Ta cần chứng minh rằng với mọi $x, y in RR^n$,
  $
    norm(x+y) <= norm(x) + norm(y).
  $

  Trước hết, ta chứng minh bất đẳng thức Cauchy–Schwarz tổng quát:
  $
    abs(x A y^T)^2 <= (x A x^T)(y A y^T).
  $

  Nếu $y=0$ thì bất đẳng thức hiển nhiên đúng.

  Nếu $y != 0$, vì $A$ xác định dương nên với mọi $t in RR$, ta có
  $
    0 & <= (x+t y) A (x+t y)^T \
      & = x A x^T + t x A y^T + t y A x^T + t^2 y A y^T \
      & = x A x^T + 2t x A y^T + t^2 y A y^T.
  $

  Ở đây, ta sử dụng tính đối xứng của $A$ để suy ra
  $
    x A y^T = y A x^T.
  $

  Tam thức bậc hai theo $t$ luôn không âm và có hệ số bậc hai $y A y^T > 0$, nên biệt thức $Delta <= 0$, tức là
  $
    4(x A y^T)^2 - 4(x A x^T)(y A y^T) <= 0.
  $

  Suy ra
  $
    abs(x A y^T) & <= sqrt(x A x^T) sqrt(y A y^T) \
                 & = norm(x) norm(y).
  $

  Áp dụng bất đẳng thức vừa chứng minh, ta có
  $
    norm(x+y)^2 & = (x+y) A (x+y)^T \
                & = x A x^T + 2x A y^T + y A y^T \
                & <= norm(x)^2 + 2norm(x)norm(y) + norm(y)^2 \
                & = (norm(x)+norm(y))^2.
  $

  Vì hai vế không âm nên lấy căn bậc hai, ta được $ norm(x+y) <= norm(x)+norm(y). $

  Vậy ánh xạ $norm(x)=sqrt(x A x^T)$ xác định một chuẩn trên $RR^n$.
]

*Bài tập 1.7.* Cho $E=M_n(RR)$ là không gian các ma trận vuông cấp $n$ trên trường số thực. Chuẩn Frobenius cho ma trận vuông được định nghĩa bởi

$ norm(A) = sqrt("trace"(A^T A)), quad A in E, $

trong đó $A^T$ là ma trận chuyển vị của $A$ và $"trace"$ là toán tử vết, bằng tổng các phần tử trên đường chéo chính. Theo định nghĩa trên, viết $norm(A)^2$ thành đa thức theo các phần tử của $A$. Chứng minh chuẩn Frobenius thực sự là một chuẩn trên $E$.

#loigiai[
  Giả sử $A=(a_(i,j)) in M_n(RR)$. Theo định nghĩa chuẩn Frobenius,
  $
    norm(A) = sqrt(upright("trace")(A^T A)).
  $

  Ta có
  $
    upright("trace")(A^T A) & = sum_(i=1)^n (A^T A)_(i,i) \
                            & = sum_(i=1)^n sum_(j=1)^n a_(j,i)^2 \
                            & = sum_(i=1)^n sum_(j=1)^n a_(i,j)^2.
  $

  Do đó,
  $
    norm(A)^2 = sum_(i=1)^n sum_(j=1)^n a_(i,j)^2.
  $

  Suy ra
  $
    norm(A) = sqrt(sum_(i=1)^n sum_(j=1)^n a_(i,j)^2).
  $

  Ta chứng minh ánh xạ trên thỏa mãn ba tiên đề của chuẩn.

  *(i)*

  Với mọi $A in M_n(RR)$, ta có
  $
    norm(A) = sqrt(sum_(i=1)^n sum_(j=1)^n a_(i,j)^2) >= 0.
  $

  Hơn nữa,
  $
    norm(A)=0 & <=> sum_(i=1)^n sum_(j=1)^n a_(i,j)^2=0 \
              & <=> a_(i,j)=0, quad forall i,j \
              & <=> A=0.
  $

  *(ii)*

  Với mọi $alpha in RR$ và $A in M_n(RR)$, ta có
  $
    norm(alpha A) & = sqrt(sum_(i=1)^n sum_(j=1)^n (alpha a_(i,j))^2) \
                  & = sqrt(alpha^2 sum_(i=1)^n sum_(j=1)^n a_(i,j)^2) \
                  & = abs(alpha) sqrt(sum_(i=1)^n sum_(j=1)^n a_(i,j)^2) \
                  & = abs(alpha) norm(A).
  $

  *(iii)*

  Cho $A=(a_(i,j))$ và $B=(b_(i,j))$ thuộc $M_n(RR)$. Ta cần chứng minh
  $
    norm(A+B) <= norm(A)+norm(B).
  $

  Theo định nghĩa,
  $
    norm(A+B)^2 & = sum_(i=1)^n sum_(j=1)^n (a_(i,j)+b_(i,j))^2 \
                & = sum_(i=1)^n sum_(j=1)^n a_(i,j)^2
                  + 2 sum_(i=1)^n sum_(j=1)^n a_(i,j)b_(i,j) \
                & quad + sum_(i=1)^n sum_(j=1)^n b_(i,j)^2.
  $

  Áp dụng bất đẳng thức Cauchy–Schwarz, ta có
  $
    abs(sum_(i=1)^n sum_(j=1)^n a_(i,j)b_(i,j)) & <= sqrt(sum_(i=1)^n sum_(j=1)^n a_(i,j)^2)
                                                  sqrt(sum_(i=1)^n sum_(j=1)^n b_(i,j)^2) \
                                                & = norm(A) norm(B).
  $

  Do đó,
  $
    norm(A+B)^2 & <= norm(A)^2 + 2norm(A)norm(B) + norm(B)^2 \
                & = (norm(A)+norm(B))^2.
  $

  Vì hai vế không âm nên lấy căn bậc hai, ta được
  $
    norm(A+B) <= norm(A)+norm(B).
  $

  Vậy chuẩn Frobenius thực sự là một chuẩn trên không gian $E=M_n(RR)$.
]

*Bài tập 1.8.* Chứng minh rằng các ánh xạ sau đây là metric trên $RR^n$:

a) $ d(x,y) := sqrt(sum_(k=1)^n abs(arctan(x_k)-arctan(y_k))^2), \
x=(x_k)_(k=1)^n, quad y=(y_k)_(k=1)^n in RR^n. $

b) $ d(x,y) := cases(
  norm(x-y)_2 & "nếu " x, y " và gốc tọa độ " O " thẳng hàng,",
  norm(x)_2+norm(y)_2 & "ngược lại,"
) $

với $norm(dot)_2$ là chuẩn Euclide trên $RR^n$.

#loigiai[
  *a)* Đặt
  $
    F: RR^n -> RR^n, quad
    F(x)=(arctan(x_1),arctan(x_2), ..., arctan(x_n)).
  $
  Khi đó $d(x,y)=norm(F(x)-F(y))_2$.

  *(i)* Với mọi $x,y in RR^n$, ta có $d(x,y)>=0$. Hơn nữa,
  $
    d(x,y)=0 & <=> F(x)=F(y) \
             & <=> arctan(x_k)=arctan(y_k), quad forall k=1,...,n \
             & <=> x_k=y_k, quad forall k=1,...,n \
             & <=> x=y,
  $
  vì hàm $arctan$ đơn ánh trên $RR$.

  *(ii)* Với mọi $x,y in RR^n$,
  $
    d(x,y)=norm(F(x)-F(y))_2
    =norm(F(y)-F(x))_2=d(y,x).
  $

  *(iii)* Với mọi $x,y,z in RR^n$, theo bất đẳng thức tam giác của chuẩn Euclide,
  $
    d(x,y) & =norm(F(x)-F(y))_2 \
           & <=norm(F(x)-F(z))_2+norm(F(z)-F(y))_2 \
           & =d(x,z)+d(z,y).
  $
  Từ (i), (ii), (iii) suy ra $d$ là một metric trên $RR^n$.

  *b)* Ta chứng minh lần lượt ba tiên đề của metric.

  *(i)* Với mọi $x,y in RR^n$, theo định nghĩa $d(x,y)>=0$. Nếu $x,y,O$ thẳng hàng thì
  $d(x,y)=0 <=> norm(x-y)_2=0 <=> x=y$.
  Nếu $x,y,O$ không thẳng hàng thì $x!=0$ và $y!=0$, nên
  $d(x,y)=norm(x)_2+norm(y)_2>0$.
  Ngược lại, $d(x,x)=norm(x-x)_2=0$.

  *(ii)* Cả điều kiện thẳng hàng lẫn hai biểu thức trong định nghĩa đều đối xứng theo $x,y$. Do đó $d(x,y)=d(y,x)$.

  *(iii)* Trước hết, với mọi $u,v in RR^n$, ta luôn có
  $
    d(u,v)>=norm(u-v)_2,
  $
  vì trong trường hợp không thẳng hàng, bất đẳng thức trên chính là
  $norm(u)_2+norm(v)_2>=norm(u-v)_2$.

  Lấy tùy ý $x,y,z in RR^n$. Ta xét hai trường hợp.

  - Nếu $x,y,O$ thẳng hàng thì
    $
      d(x,y) & =norm(x-y)_2 \
             & <=norm(x-z)_2+norm(z-y)_2 \
             & <=d(x,z)+d(z,y).
    $
  - Nếu $x,y,O$ không thẳng hàng thì $d(x,y)=norm(x)_2+norm(y)_2$.
    Nếu $z=0$ thì
    $
      d(x,z)+d(z,y)=norm(x)_2+norm(y)_2=d(x,y).
    $
    Nếu $z!=0$, không thể đồng thời có $x,z,O$ thẳng hàng và $z,y,O$ thẳng hàng, vì khi ấy $x,y,O$ cũng thẳng hàng.

    Giả sử $x,z,O$ không thẳng hàng. Khi đó
    $
      d(x,z)+d(z,y) & >=norm(x)_2+norm(z)_2+norm(z-y)_2 \
                    & >=norm(x)_2+norm(y)_2=d(x,y).
    $
    Trường hợp $z,y,O$ không thẳng hàng được chứng minh tương tự.

  Vậy trong mọi trường hợp đều có $d(x,y)<=d(x,z)+d(z,y)$.
  Từ (i), (ii), (iii) suy ra $d$ là một metric trên $RR^n$.
]

*Bài tập 1.9.* Cho không gian $C([0,1],RR)$ các hàm thực liên tục trên $[0,1]$. Chứng minh rằng các ánh xạ sau là chuẩn của không gian kể trên.

a) $norm(f)_oo = sup_(x in [0,1]) abs(f(x)).$

b) $norm(f)_1 = integral_0^1 abs(f(x)) dif x.$

c) $norm(f)_2 = (integral_0^1 abs(f(x))^2 dif x)^(1/2).$

#loigiai[
  *a)* Đặt $N_oo(f)=sup_(x in [0,1]) abs(f(x))$.
  Vì $f$ liên tục trên đoạn compact $[0,1]$ nên $abs(f)$ bị chặn và đạt giá trị lớn nhất. Do đó $N_oo(f)$ hữu hạn với mọi $f in C([0,1],RR)$.

  *(i)* Có $N_oo(f)>=0$ và
  $
    N_oo(f)=0 & <=> abs(f(x))=0, quad forall x in [0,1] \
              & <=> f=0.
  $

  *(ii)* Với mọi $alpha in RR$,
  $
    N_oo(alpha f) & =sup_(x in [0,1]) abs(alpha f(x)) \
                  & =abs(alpha) sup_(x in [0,1]) abs(f(x)) \
                  & =abs(alpha)N_oo(f).
  $

  *(iii)* Với mọi $f,g in C([0,1],RR)$ và $x in [0,1]$, ta có
  $
    abs(f(x)+g(x))<=abs(f(x))+abs(g(x))
    <=N_oo(f)+N_oo(g).
  $
  Lấy supremum theo $x$, suy ra $N_oo(f+g)<=N_oo(f)+N_oo(g)$.
  Vậy $norm(dot)_oo$ là một chuẩn.

  *b)* Đặt $N_1(f)=integral_0^1 abs(f(x)) dif x$.
  Vì $abs(f)$ liên tục trên $[0,1]$ nên tích phân tồn tại và hữu hạn.

  *(i)* Có $N_1(f)>=0$. Nếu $f=0$ thì $N_1(f)=0$.
  Ngược lại, giả sử $N_1(f)=0$ nhưng tồn tại $x_0 in [0,1]$ sao cho $f(x_0)!=0$. Do tính liên tục, tồn tại một khoảng $I$ có độ dài dương trong $[0,1]$ và $c>0$ sao cho $abs(f(x))>=c$ với mọi $x in I$. Suy ra
  $
    N_1(f)>=integral_I abs(f(x)) dif x>=c abs(I)>0,
  $
  mâu thuẫn. Vậy $f=0$.

  *(ii)* Với mọi $alpha in RR$,
  $
    N_1(alpha f) & =integral_0^1 abs(alpha f(x)) dif x \
                 & =abs(alpha) integral_0^1 abs(f(x)) dif x \
                 & =abs(alpha)N_1(f).
  $

  *(iii)* Với mọi $f,g in C([0,1],RR)$,
  $
    N_1(f+g) & =integral_0^1 abs(f(x)+g(x)) dif x \
             & <=integral_0^1 (abs(f(x))+abs(g(x))) dif x \
             & =N_1(f)+N_1(g).
  $
  Vậy $norm(dot)_1$ là một chuẩn.

  *c)* Đặt $N_2(f)=(integral_0^1 abs(f(x))^2 dif x)^(1/2)$.
  Vì $f^2$ liên tục trên $[0,1]$ nên $N_2(f)$ xác định và hữu hạn.

  *(i)* Hiển nhiên $N_2(f)>=0$. Lập luận như câu b), áp dụng cho hàm liên tục không âm $f^2$, ta có
  $
    N_2(f)=0 <=> integral_0^1 f(x)^2 dif x=0 <=> f=0.
  $

  *(ii)* Với mọi $alpha in RR$,
  $
    N_2(alpha f) & =(integral_0^1 alpha^2 f(x)^2 dif x)^(1/2) \
                 & =abs(alpha)N_2(f).
  $

  *(iii)* Theo bất đẳng thức Cauchy–Schwarz cho tích phân,
  $
    abs(integral_0^1 f(x)g(x) dif x)
    <=N_2(f)N_2(g).
  $
  Do đó
  $
    N_2(f+g)^2 & =integral_0^1 (f(x)+g(x))^2 dif x \
               & =N_2(f)^2+2integral_0^1 f(x)g(x) dif x+N_2(g)^2 \
               & <=N_2(f)^2+2N_2(f)N_2(g)+N_2(g)^2 \
               & =(N_2(f)+N_2(g))^2.
  $
  Lấy căn bậc hai hai vế, ta được $N_2(f+g)<=N_2(f)+N_2(g)$.
  Vậy $norm(dot)_2$ là một chuẩn.
]

*Bài tập 1.10.* Cho không gian $C^1([0,1],RR)$ các hàm thực khả vi liên tục trên $[0,1]$. Chứng minh rằng các ánh xạ sau là chuẩn của không gian kể trên.

a) $norm(f) = sup_(x in [0,1]) abs(f(x)) + sup_(x in [0,1]) abs(f'(x)).$

b) $norm(f) = abs(f(0)) + sup_(x in [0,1]) abs(f'(x)).$

#loigiai[
  *a)* Đặt
  $
    N(f)=sup_(x in [0,1]) abs(f(x))+sup_(x in [0,1]) abs(f'(x)).
  $
  Vì $f,f'$ liên tục trên $[0,1]$ nên cả hai supremum đều hữu hạn.

  *(i)* Rõ ràng $N(f)>=0$. Nếu $N(f)=0$ thì
  $sup_(x in [0,1]) abs(f(x))=0$, suy ra $f=0$.
  Chiều ngược lại hiển nhiên.

  *(ii)* Với mọi $alpha in RR$, do $(alpha f)'=alpha f'$ nên
  $
    N(alpha f) & =sup_(x in [0,1]) abs(alpha f(x))
                 +sup_(x in [0,1]) abs(alpha f'(x)) \
               & =abs(alpha)N(f).
  $

  *(iii)* Với mọi $f,g in C^1([0,1],RR)$, dùng bất đẳng thức tam giác và $(f+g)'=f'+g'$, ta được
  $
    N(f+g) & <=sup_(x in [0,1]) abs(f(x))+sup_(x in [0,1]) abs(g(x)) \
           & quad+sup_(x in [0,1]) abs(f'(x))+sup_(x in [0,1]) abs(g'(x)) \
           & =N(f)+N(g).
  $
  Vậy $N$ là một chuẩn trên $C^1([0,1],RR)$.

  *b)* Đặt
  $
    N(f)=abs(f(0))+sup_(x in [0,1]) abs(f'(x)).
  $
  Ánh xạ $N$ hữu hạn vì $f'$ liên tục trên $[0,1]$.

  *(i)* Có $N(f)>=0$. Giả sử $N(f)=0$. Khi đó $f(0)=0$ và $f'(x)=0$ với mọi $x in [0,1]$. Theo định lý giá trị trung bình, $f$ là hàm hằng trên $[0,1]$. Vì $f(0)=0$ nên $f=0$.
  Ngược lại, $f=0$ thì $N(f)=0$.

  *(ii)* Với mọi $alpha in RR$,
  $
    N(alpha f) & =abs(alpha f(0))+sup_(x in [0,1]) abs(alpha f'(x)) \
               & =abs(alpha)N(f).
  $

  *(iii)* Với mọi $f,g in C^1([0,1],RR)$,
  $
    N(f+g) & =abs(f(0)+g(0))+sup_(x in [0,1]) abs(f'(x)+g'(x)) \
           & <=abs(f(0))+abs(g(0)) \
           & quad+sup_(x in [0,1]) abs(f'(x))+sup_(x in [0,1]) abs(g'(x)) \
           & =N(f)+N(g).
  $
  Vậy $N$ là một chuẩn trên $C^1([0,1],RR)$.
]

*Bài tập 1.11.* Cho các không gian định chuẩn $(E_1, abs(dot)_1), (E_2, abs(dot)_2), ..., (E_n, abs(dot)_n)$. Xét tập tích

$
  E = E_1 times E_2 times dots.c times E_n \
  = {x = (x_1,x_2, ..., x_n) | x_i in E_i, i=1,2, ..., n}.
$

Chứng minh rằng các ánh xạ

a) $norm(x)_1 = abs(x_1)_1 + ... + abs(x_n)_n,$

b) $norm(x)_2 = (abs(x_1)_1^2 + ... + abs(x_n)_n^2)^(1/2),$

c) $norm(x)_oo = max_(i=1, ..., n) abs(x_i)_i,$

với $x=(x_1,x_2, ..., x_n) in E$, là các chuẩn trên $E$.

#loigiai[
  Với $x=(x_1,...,x_n) in E$, đặt $a_i=abs(x_i)_i>=0$. Do $n$ hữu hạn và mỗi $abs(dot)_i$ là một chuẩn nên cả ba ánh xạ đều xác định và hữu hạn.

  *a)* Xét $N_1(x)=sum_(i=1)^n abs(x_i)_i$.

  *(i)* Có $N_1(x)>=0$ và
  $
    N_1(x)=0 & <=> abs(x_i)_i=0, quad forall i=1,...,n \
             & <=> x_i=0, quad forall i=1,...,n \
             & <=> x=0.
  $

  *(ii)* Với mọi $alpha in RR$,
  $
    N_1(alpha x) & =sum_(i=1)^n abs(alpha x_i)_i \
                 & =abs(alpha) sum_(i=1)^n abs(x_i)_i=abs(alpha)N_1(x).
  $

  *(iii)* Với mọi $x,y in E$,
  $
    N_1(x+y) & =sum_(i=1)^n abs(x_i+y_i)_i \
             & <=sum_(i=1)^n (abs(x_i)_i+abs(y_i)_i) \
             & =N_1(x)+N_1(y).
  $
  Vậy $N_1$ là một chuẩn trên $E$.

  *b)* Xét $N_2(x)=(sum_(i=1)^n abs(x_i)_i^2)^(1/2)$.

  *(i)* Có $N_2(x)>=0$ và
  $
    N_2(x)=0 <=> abs(x_i)_i=0, quad forall i <=> x=0.
  $

  *(ii)* Với mọi $alpha in RR$,
  $
    N_2(alpha x) & =(sum_(i=1)^n abs(alpha x_i)_i^2)^(1/2) \
                 & =abs(alpha)N_2(x).
  $

  *(iii)* Lấy $x,y in E$, đặt
  $
    a_i=abs(x_i)_i, quad b_i=abs(y_i)_i.
  $
  Vì $abs(x_i+y_i)_i<=a_i+b_i$ nên
  $
    N_2(x+y) & <= (sum_(i=1)^n (a_i+b_i)^2)^(1/2) \
             & <= (sum_(i=1)^n a_i^2)^(1/2)+(sum_(i=1)^n b_i^2)^(1/2) \
             & =N_2(x)+N_2(y),
  $
  trong đó bất đẳng thức thứ hai là bất đẳng thức Minkowski đối với chuẩn Euclide trên $RR^n$.
  Vậy $N_2$ là một chuẩn trên $E$.

  *c)* Xét $N_oo(x)=max_(i=1,...,n) abs(x_i)_i$.

  *(i)* Có $N_oo(x)>=0$ và
  $
    N_oo(x)=0 <=> abs(x_i)_i=0, quad forall i <=> x=0.
  $

  *(ii)* Với mọi $alpha in RR$,
  $
    N_oo(alpha x) & =max_(i=1,...,n) abs(alpha x_i)_i \
                  & =abs(alpha)N_oo(x).
  $

  *(iii)* Với mọi $x,y in E$ và mọi $i$, ta có
  $
    abs(x_i+y_i)_i & <=abs(x_i)_i+abs(y_i)_i \
                   & <=N_oo(x)+N_oo(y).
  $
  Lấy giá trị lớn nhất theo $i$ suy ra $N_oo(x+y)<=N_oo(x)+N_oo(y)$.
  Vậy $N_oo$ là một chuẩn trên $E$.
]

*Bài tập 1.12.* Chứng minh các chuẩn đã định nghĩa ở Bài tập 1.11 là tương đương. Cụ thể hơn, chứng minh rằng

$ norm(x)_oo <= norm(x)_2 <= norm(x)_1 <= n norm(x)_oo $

với mọi $x in E$.

#loigiai[
  Lấy tùy ý $x=(x_1,...,x_n) in E$ và đặt $a_i=abs(x_i)_i>=0$.

  Trước hết, với mọi $i=1,...,n$,
  $
    a_i^2<=sum_(j=1)^n a_j^2.
  $
  Suy ra
  $
    norm(x)_oo=max_(i=1,...,n) a_i
    <=(sum_(i=1)^n a_i^2)^(1/2)=norm(x)_2.
  $

  Mặt khác, vì $a_i>=0$ nên
  $
    (sum_(i=1)^n a_i)^2
    =sum_(i=1)^n a_i^2+2 sum_(1<=i<j<=n) a_i a_j
    >=sum_(i=1)^n a_i^2.
  $
  Lấy căn bậc hai hai vế, ta được
  $
    norm(x)_2<=sum_(i=1)^n a_i=norm(x)_1.
  $

  Cuối cùng, $a_i<=max_(j=1,...,n) a_j=norm(x)_oo$ với mọi $i$ nên
  $
    norm(x)_1=sum_(i=1)^n a_i<=n norm(x)_oo.
  $

  Kết hợp các bất đẳng thức trên,
  $
    norm(x)_oo<=norm(x)_2<=norm(x)_1<=n norm(x)_oo.
  $
  Do đó ba chuẩn $norm(dot)_1$, $norm(dot)_2$ và $norm(dot)_oo$ tương đương trên $E$.
]

*Bài tập 1.13.* Cho $E$ là một không gian vector trên trường số thực $RR$ sao cho $0 < dim(E) < oo$. Chứng minh rằng tồn tại một số tự nhiên $n$ và một chuẩn $norm(dot)_E$ trên $E$ sao cho tồn tại một đẳng cấu tuyến tính $phi: E -> RR^n$ thỏa $phi$ là một phép đẳng cự, nghĩa là

$ norm(x)_E = norm(phi(x))_2 quad forall x in E, $

trong đó $norm(dot)_2$ là chuẩn Euclide thông thường trên $RR^n$.

// LƯU Ý BẢN GỐC: Vế phải bất đẳng thức Hölder tại đây ghi |x_i|^q
// trong tổng thứ hai; thông thường công thức đúng phải là |y_i|^q.
// Phần bên dưới giữ nguyên ký hiệu in trong tài liệu nguồn.
#loigiai[
  Vì $0<dim(E)<oo$, đặt $n=dim(E)$ và chọn một cơ sở $(e_1,e_2,...,e_n)$ của $E$.

  Mọi $x in E$ được biểu diễn duy nhất dưới dạng
  $
    x=a_1 e_1+a_2 e_2+...+a_n e_n,
    quad a_i in RR.
  $
  Định nghĩa ánh xạ
  $
    phi: E -> RR^n, quad
    phi(x)=(a_1,a_2,...,a_n).
  $
  Theo tính duy nhất của tọa độ trên một cơ sở, $phi$ là song ánh. Hơn nữa, với mọi $x,y in E$ và $alpha,beta in RR$,
  $
    phi(alpha x+beta y)=alpha phi(x)+beta phi(y).
  $
  Vậy $phi$ là một đẳng cấu tuyến tính.

  Trên $E$, ta định nghĩa
  $
    norm(x)_E:=norm(phi(x))_2
    =(sum_(i=1)^n a_i^2)^(1/2).
  $
  Ta kiểm tra các tiên đề của chuẩn.

  *(i)* Có $norm(x)_E>=0$ và
  $
    norm(x)_E=0
    <=> phi(x)=0
    <=> x=0,
  $
  vì $phi$ đơn ánh.

  *(ii)* Với mọi $alpha in RR$,
  $
    norm(alpha x)_E & =norm(phi(alpha x))_2 \
                    & =norm(alpha phi(x))_2=abs(alpha)norm(x)_E.
  $

  *(iii)* Với mọi $x,y in E$,
  $
    norm(x+y)_E & =norm(phi(x)+phi(y))_2 \
                & <=norm(phi(x))_2+norm(phi(y))_2 \
                & =norm(x)_E+norm(y)_E.
  $
  Do đó $norm(dot)_E$ là một chuẩn trên $E$. Theo cách định nghĩa, ta có
  $
    norm(x)_E=norm(phi(x))_2, quad forall x in E.
  $
  Vậy $phi$ là một phép đẳng cự từ $(E,norm(dot)_E)$ lên $(RR^n,norm(dot)_2)$.
]

*Bài tập 1.14.* Cho các số thực dương $p,q in (1,oo)$ sao cho $frac(1, p) + frac(1, q) = 1$. Chứng minh _Bất đẳng thức Holder_:

$ sum_(i=1)^n abs(x_i y_i) <= (sum_(i=1)^n abs(x_i)^p)^(1/p) (sum_(i=1)^n abs(x_i)^q)^(1/q), $

với mọi $x=(x_1, ..., x_n)$ và $y=(y_1, ..., y_n)$ trong $RR^n$.

_Gợi ý:_ Dùng _Bất đẳng thức Young_ dạng $a b <= frac(lambda^p a^p, p) + frac(b^q, lambda^q q)$, $a,b > 0$, sau đó chọn tham số $lambda > 0$ hợp lý.

#loigiai[
  _Lưu ý về đề bài:_ Trong bản gốc, thừa số thứ hai ở vế phải ghi $sum_(i=1)^n abs(x_i)^q$. Công thức Hölder đúng phải là $sum_(i=1)^n abs(y_i)^q$. Ta chứng minh công thức đúng này.

  Đặt
  $
    X=(sum_(i=1)^n abs(x_i)^p)^(1/p), quad
    Y=(sum_(i=1)^n abs(y_i)^q)^(1/q).
  $
  Nếu $X=0$ hoặc $Y=0$ thì $x=0$ hoặc $y=0$, và bất đẳng thức hiển nhiên đúng.

  Giả sử $X>0$ và $Y>0$. Theo bất đẳng thức Young, với mọi $a,b>=0$ và $lambda>0$,
  $
    a b<=frac(lambda^p a^p, p)+frac(b^q, q lambda^q).
  $
  Thay $a=abs(x_i)$, $b=abs(y_i)$ rồi lấy tổng theo $i$, ta được
  $
    sum_(i=1)^n abs(x_i y_i) & <=frac(lambda^p, p)sum_(i=1)^n abs(x_i)^p
                               +frac(1, q lambda^q)sum_(i=1)^n abs(y_i)^q \
                             & =frac(lambda^p X^p, p)+frac(Y^q, q lambda^q).
  $

  Chọn
  $
    lambda=(Y^q/X^p)^(1/(p+q))>0.
  $
  Vì $1/p+1/q=1$ nên $p+q=p q$. Do đó
  $
    lambda^p X^p=X Y,
    quad Y^q/lambda^q=X Y.
  $
  Thay vào bất đẳng thức trên,
  $
    sum_(i=1)^n abs(x_i y_i) & <=X Y/p+X Y/q \
                             & =(1/p+1/q)X Y \
                             & =X Y.
  $
  Vậy
  $
    sum_(i=1)^n abs(x_i y_i)
    <=(sum_(i=1)^n abs(x_i)^p)^(1/p)
    (sum_(i=1)^n abs(y_i)^q)^(1/q).
  $
]

*Bài tập 1.15.* Sử dụng _Bất đẳng thức Holder_, chứng minh _Bất đẳng thức Minkowski_:

$ (sum_(i=1)^n abs(x_i+y_i)^p)^(1/p) <= (sum_(i=1)^n abs(x_i)^p)^(1/p) + (sum_(i=1)^n abs(y_i)^p)^(1/p), $

với mọi $p in [1,oo)$, $x=(x_1, ..., x_n)$ và $y=(y_1, ..., y_n)$ trong $RR^n$. Từ đó suy ra ánh xạ $norm(dot)_p: RR^n -> RR$, $x=(x_1, ..., x_n) ↦ norm(x)_p = (sum_(i=1)^n abs(x_i)^p)^(1/p)$ xác định một chuẩn trên $RR^n$.

#loigiai[
  Ta chứng minh bất đẳng thức Minkowski theo hai trường hợp.

  *Trường hợp $p=1$.* Theo bất đẳng thức tam giác của giá trị tuyệt đối,
  $
    sum_(i=1)^n abs(x_i+y_i) & <=sum_(i=1)^n (abs(x_i)+abs(y_i)) \
                             & =sum_(i=1)^n abs(x_i)+sum_(i=1)^n abs(y_i).
  $
  Đây chính là bất đẳng thức cần chứng minh khi $p=1$.

  *Trường hợp $p>1$.* Chọn $q=p/(p-1)$, khi đó $1/p+1/q=1$.
  Đặt
  $
    S=(sum_(i=1)^n abs(x_i+y_i)^p)^(1/p).
  $
  Nếu $S=0$ thì bất đẳng thức hiển nhiên đúng. Giả sử $S>0$.

  Theo bất đẳng thức tam giác và bất đẳng thức Hölder,
  $
    S^p & =sum_(i=1)^n abs(x_i+y_i)^p \
        & <=sum_(i=1)^n (abs(x_i)+abs(y_i))abs(x_i+y_i)^(p-1) \
        & =sum_(i=1)^n abs(x_i)abs(x_i+y_i)^(p-1) \
        & quad+sum_(i=1)^n abs(y_i)abs(x_i+y_i)^(p-1) \
        & <= (sum_(i=1)^n abs(x_i)^p)^(1/p)
          (sum_(i=1)^n abs(x_i+y_i)^((p-1)q))^(1/q) \
        & quad+(sum_(i=1)^n abs(y_i)^p)^(1/p)
          (sum_(i=1)^n abs(x_i+y_i)^((p-1)q))^(1/q).
  $
  Vì $(p-1)q=p$, nên
  $
    S^p<= (norm(x)_p+norm(y)_p) S^(p-1).
  $
  Chia hai vế cho $S^(p-1)>0$, ta được
  $
    norm(x+y)_p=S<=norm(x)_p+norm(y)_p.
  $

  Từ đó ta chứng minh $norm(dot)_p$ là một chuẩn trên $RR^n$.

  *(i)* Có $norm(x)_p>=0$ và
  $
    norm(x)_p=0
    <=> sum_(i=1)^n abs(x_i)^p=0
    <=> x_i=0, quad forall i
    <=> x=0.
  $

  *(ii)* Với mọi $alpha in RR$,
  $
    norm(alpha x)_p & =(sum_(i=1)^n abs(alpha x_i)^p)^(1/p) \
                    & =abs(alpha)norm(x)_p.
  $

  *(iii)* Bất đẳng thức Minkowski đã chứng minh ở trên cho ta
  $
    norm(x+y)_p<=norm(x)_p+norm(y)_p.
  $
  Vậy $norm(dot)_p$ là một chuẩn trên $RR^n$ với mọi $p in [1,oo)$.
]

*Bài tập 1.16.* Cho $x in RR^n$ tùy ý. Chứng tỏ rằng

$ lim_(p -> oo) norm(x)_p = norm(x)_oo. $

#loigiai[
  Lấy $x=(x_1,...,x_n) in RR^n$ tùy ý và đặt
  $
    M=max_(i=1,...,n) abs(x_i)=norm(x)_oo.
  $
  Nếu $M=0$ thì $x=0$ và $norm(x)_p=0$ với mọi $p>=1$. Do đó kết luận hiển nhiên đúng.

  Giả sử $M>0$. Vì $abs(x_i)<=M$ với mọi $i$, nên
  $
    M^p<=sum_(i=1)^n abs(x_i)^p<=n M^p.
  $
  Lấy căn bậc $p$ hai vế, ta được
  $
    M<=norm(x)_p<=n^(1/p)M.
  $
  Mà $lim_(p->oo)n^(1/p)=1$ nên theo định lý kẹp,
  $
    lim_(p->oo)norm(x)_p=M=norm(x)_oo.
  $
]

*Bài tập 1.17.* Lấy bất kỳ $p,q in [1,oo)$. Chứng minh rằng chuẩn $norm(dot)_p$ và $norm(dot)_q$ trên $RR^n$ là tương đương.

_Gợi ý:_ Chứng minh chuẩn $norm(dot)_1$ tương đương với chuẩn $norm(dot)_p$, $p in [1,oo)$, rồi dùng tính chất bắc cầu của quan hệ tương đương.

#v(0.5em)
Một trường hợp mở rộng của không gian vector hữu hạn chiều $RR^n$ lên vô hạn chiều là khi người ta, thay vì quan sát các bộ $n$ số thực, sẽ xem xét các bộ có vô hạn phần tử, hay các dãy. Chính xác hơn, ta định nghĩa

$ RR^NN = p r o d_(n=1)^oo RR := {x: NN -> RR}, $

trong đó $x$ là các ánh xạ từ $NN$ tới $RR$. Nếu ta đặt $x_n := x(n)$, thì một cách hình thức, ta có thể mô tả ánh xạ $x$ bởi tập các giá trị được xếp thứ tự của nó như sau

$ x equiv (x(1), x(2), ..., x(n), ...) = (x_1,x_2, ..., x_n, ...). $

Tuy nhiên, định nghĩa của $RR^NN$ không đủ để ta xây dựng các chuẩn. Do đó, thay vì $RR^NN$, người ta thêm vào một số điều kiện và xem xét các tập con của nó như sau:

$
  ell^p = {x=(x_1,x_2, ..., x_n, ...): \
    x_i in RR, i=1,2, ..., "và" sum_(i=1)^oo abs(x_i)^p < oo},
$

nếu $p in [1,oo)$ và

$
  ell^oo = {x=(x_1,x_2, ..., x_n, ...): \
    x_i in RR, i=1,2, ..., "và" sup_(i=1,2,...) abs(x_i) < oo}.
$

#loigiai[
  Ta chứng minh rằng với mọi $p in [1,oo)$ và $x in RR^n$,
  $
    norm(x)_p<=norm(x)_1<=n^(1-1/p)norm(x)_p.
  $

  Trường hợp $p=1$ là đẳng thức. Xét $p>1$.
  Đặt $A=sum_(i=1)^n abs(x_i)=norm(x)_1$.
  Nếu $A=0$ thì $x=0$ và các bất đẳng thức hiển nhiên đúng.
  Nếu $A>0$, vì $abs(x_i)<=A$, ta có
  $
    sum_(i=1)^n abs(x_i)^p
    <=A^(p-1)sum_(i=1)^n abs(x_i)=A^p.
  $
  Lấy căn bậc $p$, suy ra $norm(x)_p<=norm(x)_1$.

  Mặt khác, đặt $q=p/(p-1)$. Áp dụng bất đẳng thức Hölder cho các dãy $(abs(x_i))$ và $(1)$, ta có
  $
    norm(x)_1 & =sum_(i=1)^n abs(x_i)c dot 1 \
              & <= (sum_(i=1)^n abs(x_i)^p)^(1/p)
                (sum_(i=1)^n 1^q)^(1/q) \
              & =n^(1/q)norm(x)_p \
              & =n^(1-1/p)norm(x)_p.
  $
  Vậy $norm(dot)_p$ tương đương với $norm(dot)_1$ trên $RR^n$.

  Với $p,q in [1,oo)$ bất kỳ, do $norm(dot)_p$ và $norm(dot)_q$ đều tương đương với $norm(dot)_1$, theo tính bắc cầu của quan hệ tương đương chuẩn, suy ra $norm(dot)_p$ và $norm(dot)_q$ tương đương.
]

*Bài tập 1.18.* Chứng minh rằng, với mọi $p in [1,oo]$, $ell^p$ là không gian vector con của không gian các dãy $RR^NN$.

#loigiai[
  Ta chứng minh $ell^p$ là không gian vector con của $RR^NN$ với mọi $p in [1,oo]$.

  *Trường hợp $1<=p<oo$.* Dãy không $0=(0,0,...)$ thuộc $ell^p$, nên $ell^p$ khác rỗng.

  Lấy $x=(x_i)$ và $y=(y_i)$ thuộc $ell^p$. Vì $p>=1$, ta có bất đẳng thức
  $
    abs(a+b)^p<=2^(p-1)(abs(a)^p+abs(b)^p),
    quad forall a,b in RR.
  $
  Thật vậy, điều này suy ra từ $abs(a+b)<=abs(a)+abs(b)$ và tính lồi của hàm $t↦t^p$ trên $[0,oo)$.
  Do đó
  $
    sum_(i=1)^oo abs(x_i+y_i)^p & <=2^(p-1)sum_(i=1)^oo (abs(x_i)^p+abs(y_i)^p) \
                                & =2^(p-1)(sum_(i=1)^oo abs(x_i)^p+sum_(i=1)^oo abs(y_i)^p) \
                                & <oo.
  $
  Suy ra $x+y in ell^p$.

  Với mọi $alpha in RR$,
  $
    sum_(i=1)^oo abs(alpha x_i)^p
    =abs(alpha)^p sum_(i=1)^oo abs(x_i)^p<oo.
  $
  Vậy $alpha x in ell^p$, suy ra $ell^p$ là không gian vector con của $RR^NN$.

  *Trường hợp $p=oo$.* Dãy không thuộc $ell^oo$.
  Với mọi $x,y in ell^oo$,
  $
    sup_(i>=1) abs(x_i+y_i) & <=sup_(i>=1) abs(x_i)+sup_(i>=1) abs(y_i) \
                            & <oo.
  $
  Do đó $x+y in ell^oo$. Với mọi $alpha in RR$,
  $
    sup_(i>=1) abs(alpha x_i)
    =abs(alpha) sup_(i>=1) abs(x_i)<oo,
  $
  nên $alpha x in ell^oo$.
  Vậy $ell^oo$ cũng là một không gian vector con của $RR^NN$.
]

*Bài tập 1.19.* Cho không gian $ell^oo$. Đặt ánh xạ $norm(dot)_oo: ell^oo -> RR$, $x=(x_1,x_2, ...) ↦ norm(x)_oo = sup_(i=1,2,...) abs(x_i)$. Chứng minh $(ell^oo, norm(dot)_oo)$ là không gian định chuẩn.

#loigiai[
  Theo Bài tập 1.18, $ell^oo$ là một không gian vector. Với mọi $x=(x_i) in ell^oo$, do dãy $(x_i)$ bị chặn nên
  $
    norm(x)_oo=sup_(i>=1) abs(x_i)<oo.
  $
  Ta chứng minh ba tiên đề của chuẩn.

  *(i)* Có $norm(x)_oo>=0$. Hơn nữa,
  $
    norm(x)_oo=0 & <=> abs(x_i)=0, quad forall i>=1 \
                 & <=> x_i=0, quad forall i>=1 \
                 & <=> x=0.
  $

  *(ii)* Với mọi $alpha in RR$,
  $
    norm(alpha x)_oo & =sup_(i>=1) abs(alpha x_i) \
                     & =abs(alpha) sup_(i>=1) abs(x_i) \
                     & =abs(alpha)norm(x)_oo.
  $

  *(iii)* Với mọi $x,y in ell^oo$, theo bất đẳng thức tam giác,
  $
    abs(x_i+y_i)
    <=abs(x_i)+abs(y_i)
    <=norm(x)_oo+norm(y)_oo,
  $
  với mọi $i>=1$. Lấy supremum theo $i$, ta được
  $
    norm(x+y)_oo<=norm(x)_oo+norm(y)_oo.
  $
  Từ (i), (ii), (iii) suy ra $(ell^oo,norm(dot)_oo)$ là một không gian định chuẩn.
]

#baitoan[ Từ các kết quả đã biết ở trường hợp hữu hạn, suy ra _Bất đẳng thức Minkowski_ cho chuỗi vô hạn:

  $ (sum_(i=1)^oo abs(x_i+y_i)^p)^(1/p) <= (sum_(i=1)^oo abs(x_i)^p)^(1/p) + (sum_(i=1)^oo abs(y_i)^p)^(1/p), $

  với $p in [1,oo)$, $x=(x_1,x_2, ...) in ell^p$.
]
#loigiai[
  _Lưu ý về giả thiết:_ Đề gốc chỉ ghi $x in ell^p$. Để hai vế đều là các số thực hữu hạn, ta bổ sung giả thiết $y=(y_i) in ell^p$.

  Với mọi $N in NN$, áp dụng bất đẳng thức Minkowski hữu hạn ở Bài tập 1.15 cho các vector $(x_1,...,x_N)$ và $(y_1,...,y_N)$, ta được
  $
    (sum_(i=1)^N abs(x_i+y_i)^p)^(1/p) & <= (sum_(i=1)^N abs(x_i)^p)^(1/p) \
                                       & quad+(sum_(i=1)^N abs(y_i)^p)^(1/p).
  $
  Vì $x,y in ell^p$ nên hai chuỗi $sum_(i=1)^oo abs(x_i)^p$ và $sum_(i=1)^oo abs(y_i)^p$ đều hội tụ. Hơn nữa, theo Bài tập 1.18, $x+y in ell^p$, do đó chuỗi $sum_(i=1)^oo abs(x_i+y_i)^p$ cũng hội tụ.

  Cho $N->oo$ trong bất đẳng thức trên. Nhờ tính liên tục của hàm $t↦t^(1/p)$ trên $[0,oo)$, ta suy ra
  $
    (sum_(i=1)^oo abs(x_i+y_i)^p)^(1/p) & <= (sum_(i=1)^oo abs(x_i)^p)^(1/p) \
                                        & quad+(sum_(i=1)^oo abs(y_i)^p)^(1/p).
  $
  Vậy bất đẳng thức Minkowski vẫn đúng cho các chuỗi vô hạn trong $ell^p$.
]

#baitoan[ Cho không gian $ell^p$, $p in [1,oo)$. Đặt ánh xạ $norm(dot)_p: ell^p -> RR$, $x=(x_1,x_2, ...) ↦ norm(x)_p = (sum_(i=1)^oo abs(x_i)^p)^(1/p)$. Chứng minh $(ell^p, norm(dot)_p)$ là không gian định chuẩn.
]
#loigiai[
  Theo Bài tập 1.18, $ell^p$ là một không gian vector. Với mọi $x=(x_i) in ell^p$, chuỗi $sum_(i=1)^oo abs(x_i)^p$ hội tụ, vì thế $norm(x)_p$ là một số thực hữu hạn.

  *(i)* Với mọi $x in ell^p$, ta có $norm(x)_p>=0$. Hơn nữa,
  $
    norm(x)_p=0 & <=> sum_(i=1)^oo abs(x_i)^p=0 \
                & <=> abs(x_i)^p=0, quad forall i>=1 \
                & <=> x=0,
  $
  vì mọi số hạng trong chuỗi đều không âm.

  *(ii)* Với mọi $alpha in RR$,
  $
    norm(alpha x)_p & =(sum_(i=1)^oo abs(alpha x_i)^p)^(1/p) \
                    & =(abs(alpha)^p sum_(i=1)^oo abs(x_i)^p)^(1/p) \
                    & =abs(alpha)norm(x)_p.
  $

  *(iii)* Với mọi $x,y in ell^p$, bất đẳng thức Minkowski vô hạn ở Bài tập 1.20 cho ta
  $
    norm(x+y)_p<=norm(x)_p+norm(y)_p.
  $
  Từ (i), (ii), (iii) suy ra $norm(dot)_p$ là một chuẩn trên $ell^p$. Vậy $(ell^p,norm(dot)_p)$ là một không gian định chuẩn với mọi $p in [1,oo)$.
]



#pagebreak()


// CÂU 1 — NỘI DUNG CÓ THỂ DÁN TRỰC TIẾP VÀO TÀI LIỆU CÓ SẴN
// Tài liệu gốc đã định nghĩa #loigiai.

#heading(level: 2)[Câu 1. Chuẩn có trọng số và sự tương đương chuẩn]

*Câu 1 (2,0 điểm).* Cho $E = RR^2$. Với $a,b > 0$ cho trước, xét ánh xạ
$
  norm(dot)_(a,b): E -> RR, quad
  x=(x_1,x_2) ↦ norm(x)_(a,b) = sqrt(a x_1^2+b x_2^2).
$

*a)* Chứng minh rằng với mọi $a,b > 0$, $(E,norm(dot)_(a,b))$ là một không gian định chuẩn.

*b)* Chứng minh rằng $norm(dot)_(1,8)$ và $norm(dot)_(7,9)$ là hai chuẩn tương đương.

=== Câu a) Chứng minh là chuẩn

*Hướng suy nghĩ.* Khi đề bài yêu cầu chứng minh một ánh xạ là chuẩn, cách trực tiếp nhất là kiểm tra ba tiên đề: tính xác định dương, tính thuần nhất và bất đẳng thức tam giác. Hai tiên đề đầu tương đối dễ vì $a,b>0$ và vì phép lấy căn. Điểm cần tìm ý tưởng là bất đẳng thức tam giác.

Biểu thức $sqrt(a x_1^2+b x_2^2)$ có dạng gần giống chuẩn Euclid $sqrt(x_1^2+x_2^2)$. Các hệ số $a,b$ có thể được đưa vào bên trong bình phương: $a x_1^2=(sqrt(a)x_1)^2$, $b x_2^2=(sqrt(b)x_2)^2$. Từ đó có hai hướng: khai triển bình phương rồi dùng Cauchy–Schwarz, hoặc biến đổi về chuẩn Euclid.

*Cách 1. Kiểm tra trực tiếp ba tiên đề.*
#loigiai[
  *(i) Tính xác định dương.* Với mọi $x=(x_1,x_2) in RR^2$, vì $a,b>0$ nên
  $
    norm(x)_(a,b)=sqrt(a x_1^2+b x_2^2)>=0.
  $
  Hơn nữa,
  $
    norm(x)_(a,b)=0 & <=> a x_1^2+b x_2^2=0 \
                    & <=> x_1=x_2=0 \
                    & <=> x=0.
  $
  Ở bước thứ hai, ta dùng tính không âm của cả hai số hạng và điều kiện $a,b>0$: tổng của hai số không âm bằng $0$ khi và chỉ khi mỗi số đều bằng $0$.

  *(ii) Tính thuần nhất.* Với mọi $lambda in RR$ và $x in RR^2$, ta có
  $
    norm(lambda x)_(a,b) & =sqrt(a (lambda x_1)^2+b (lambda x_2)^2) \
                         & =sqrt(lambda^2(a x_1^2+b x_2^2)) \
                         & =abs(lambda) sqrt(a x_1^2+b x_2^2) \
                         & =abs(lambda) norm(x)_(a,b).
  $
  Chú ý rằng $sqrt(lambda^2)=abs(lambda)$, không phải lúc nào cũng bằng $lambda$.

  *(iii) Bất đẳng thức tam giác.* Lấy tùy ý $x=(x_1,x_2)$ và $y=(y_1,y_2)$ thuộc $RR^2$. Ta cần chứng minh
  $
    norm(x+y)_(a,b) <= norm(x)_(a,b)+norm(y)_(a,b).
  $
  Để xử lý dấu căn, trước hết ta xét bình phương vế trái. Ta có
  $
    norm(x+y)_(a,b)^2 & =a(x_1+y_1)^2+b(x_2+y_2)^2 \
                      & =(a x_1^2+b x_2^2)+(a y_1^2+b y_2^2) \
                      & quad +2(a x_1 y_1+b x_2 y_2).
  $
  Ta cần ước lượng số hạng chéo $a x_1 y_1+b x_2 y_2$. Áp dụng bất đẳng thức Cauchy–Schwarz cho hai vector $(sqrt(a)x_1,sqrt(b)x_2)$ và $(sqrt(a)y_1,sqrt(b)y_2)$, ta được
  $
    abs(a x_1 y_1+b x_2 y_2) & <=sqrt(a x_1^2+b x_2^2) \
                             & quad dot sqrt(a y_1^2+b y_2^2) \
                             & =norm(x)_(a,b) norm(y)_(a,b).
  $
  Suy ra
  $
    norm(x+y)_(a,b)^2 & <=norm(x)_(a,b)^2+norm(y)_(a,b)^2 \
                      & quad +2 norm(x)_(a,b) norm(y)_(a,b) \
                      & =(norm(x)_(a,b)+norm(y)_(a,b))^2.
  $
  Vì hai vế đều không âm, lấy căn bậc hai suy ra
  $
    norm(x+y)_(a,b)<=norm(x)_(a,b)+norm(y)_(a,b).
  $
  Từ (i), (ii), (iii), kết luận $norm(dot)_(a,b)$ là một chuẩn trên $RR^2$, với mọi $a,b>0$.
]

*Cách 2. Đưa về chuẩn Euclid bằng một ánh xạ tuyến tính.*

*Vì sao nghĩ ra?* Khi gặp căn của tổng các bình phương có hệ số dương, ta thử hấp thụ hệ số vào tọa độ để xuất hiện chuẩn Euclid. Thay vì chứng minh lại bất đẳng thức tam giác từ đầu, ta tận dụng ngay ba tính chất đã biết của chuẩn Euclid.
#loigiai[
  Xét ánh xạ
  $
    T:RR^2 -> RR^2, quad
    T(x_1,x_2)=(sqrt(a)x_1,sqrt(b)x_2).
  $
  Rõ ràng $T$ là ánh xạ tuyến tính. Hơn nữa, vì $a,b>0$ nên
  $
    T(x)=0 <=> x_1=x_2=0 <=> x=0,
  $
  nghĩa là $T$ đơn ánh. Theo định nghĩa chuẩn Euclid,
  $
    norm(x)_(a,b)=norm(T(x))_2.
  $
  Do đó, với mọi $x,y in RR^2$ và $lambda in RR$,
  $
           norm(x)_(a,b) & =norm(T(x))_2 >=0, \
         norm(x)_(a,b)=0 & <=>T(x)=0<=>x=0, \
    norm(lambda x)_(a,b) & =norm(T(lambda x))_2 \
                         & =norm(lambda T(x))_2=abs(lambda)norm(x)_(a,b), \
         norm(x+y)_(a,b) & =norm(T(x)+T(y))_2 \
                         & <=norm(T(x))_2+norm(T(y))_2 \
                         & =norm(x)_(a,b)+norm(y)_(a,b).
  $
  Vậy $norm(dot)_(a,b)$ là một chuẩn trên $RR^2$.
]

*Nhận xét.* Có thể viết $norm(x)_(a,b)=sqrt(x A x^T)$ với $A="diag"(a,b)$ nếu coi $x$ là vector hàng. Ma trận $A$ đối xứng, xác định dương vì $a,b>0$. Đây là trường hợp riêng của kết quả về chuẩn sinh bởi ma trận xác định dương trong Bài tập 1.6 của tài liệu.

Điều kiện $a,b>0$ rất quan trọng. Chẳng hạn nếu $a=0$ thì $norm((1,0))_(0,b)=0$ mặc dù $(1,0)!=0$, nên không còn là chuẩn.

=== Câu b) Chứng minh hai chuẩn tương đương

*Hướng suy nghĩ.* Ta không cần chứng minh lại ba tiên đề vì câu a) đã cho biết hai ánh xạ đang xét đều là chuẩn. Theo định nghĩa, cần tìm $m,M>0$ sao cho
$
  m norm(x)_(1,8) <= norm(x)_(7,9)
  <= M norm(x)_(1,8), quad forall x in RR^2.
$

Hai chuẩn đều có dạng căn bậc hai của tổng các bình phương không âm. Vì hàm căn tăng trên $[0,+oo)$, việc tìm $m,M$ có thể chuyển thành so sánh hệ số của $x_1^2$ và $x_2^2$ sau khi bình phương. Đó là lý do tự nhiên để xét các tỉ số $7/1$ và $9/8$.

*Cách 1. So sánh trực tiếp hệ số (cho hằng số tốt nhất).*
#loigiai[
  Với $x=(x_1,x_2) in RR^2$, ta có
  $
    norm(x)_(1,8)^2 & = x_1^2+8x_2^2, \
    norm(x)_(7,9)^2 & = 7x_1^2+9x_2^2.
  $
  Vì $7>=9/8$ và $9=(9/8) dot 8$, suy ra
  $
    7x_1^2+9x_2^2 & >=frac(9, 8)x_1^2+9x_2^2 \
                  & =frac(9, 8)(x_1^2+8x_2^2).
  $
  Do đó,
  $
    norm(x)_(7,9)>=sqrt(frac(9, 8))norm(x)_(1,8)
    =frac(3, 2 sqrt(2))norm(x)_(1,8).
  $
  Mặt khác, vì $9<=7 dot 8$, ta có
  $
    7x_1^2+9x_2^2 & <=7x_1^2+56x_2^2 \
                  & =7(x_1^2+8x_2^2).
  $
  Suy ra
  $
    norm(x)_(7,9)<=sqrt(7)norm(x)_(1,8).
  $
  Kết hợp hai bất đẳng thức,
  $
    frac(3, 2 sqrt(2))norm(x)_(1,8)
    <= norm(x)_(7,9)
    <= sqrt(7)norm(x)_(1,8),
  $
  với mọi $x in RR^2$. Chọn $m=3/(2 sqrt(2))>0$ và $M=sqrt(7)>0$. Vậy $norm(dot)_(1,8)$ và $norm(dot)_(7,9)$ tương đương.
]

*Tại sao đây là hai hằng số tốt nhất?* Xét $x=(0,t)$ với $t!=0$, ta được
$
  frac(norm(x)_(7,9), norm(x)_(1,8))=frac(3, 2 sqrt(2)).
$
Còn khi $x=(t,0)$ với $t!=0$,
$
  frac(norm(x)_(7,9), norm(x)_(1,8))=sqrt(7).
$
Vì đạt dấu bằng ở cả hai đầu nên không thể tăng hằng số chặn dưới hoặc giảm hằng số chặn trên.

*Cách 2. So sánh qua chuẩn Euclid.*

*Vì sao nghĩ ra?* Nếu chỉ cần chứng minh sự tương đương, không nhất thiết phải tìm hằng số tối ưu. Ta có thể lấy chuẩn Euclid làm chuẩn trung gian và ước lượng từng chuẩn riêng rẽ. Cách này dễ nhớ và thường áp dụng được khi các hệ số phức tạp hơn.
#loigiai[
  Với mọi $x in RR^2$, vì
  $
    x_1^2+x_2^2 <= x_1^2+8x_2^2
    <= 8(x_1^2+x_2^2),
  $
  nên
  $
    norm(x)_2 <= norm(x)_(1,8) <= sqrt(8)norm(x)_2.
  $
  Tương tự, từ
  $
    7(x_1^2+x_2^2) <= 7x_1^2+9x_2^2
    <=9(x_1^2+x_2^2),
  $
  ta có
  $
    sqrt(7)norm(x)_2 <= norm(x)_(7,9)
    <=3norm(x)_2.
  $
  Kết hợp hai chuỗi bất đẳng thức,
  $
    sqrt(frac(7, 8))norm(x)_(1,8)
    <=norm(x)_(7,9)
    <=3norm(x)_(1,8).
  $
  Do $sqrt(7/8)>0$ và $3>0$, hai chuẩn đã cho tương đương.
]

*Nhận xét.* Các hằng số trong Cách 2 yếu hơn Cách 1, nhưng vẫn hoàn toàn đủ để chứng minh tương đương chuẩn. Định nghĩa chỉ yêu cầu tồn tại hai hằng số dương, không yêu cầu chúng là tốt nhất.

*Cách 3. Tỉ số bình phương là một trung bình có trọng số.*

*Vì sao nghĩ ra?* Cách 1 so sánh riêng từng hệ số; ta có thể nhìn sâu hơn bằng cách chia hai biểu thức bình phương cho nhau. Khi đó, tỉ số cần ước lượng trở thành trung bình của hai số $7$ và $9/8$, nên tự động nằm giữa chúng.
#loigiai[
  Với $x != 0$, đặt
  $
    t=frac(x_1^2, x_1^2+8x_2^2).
  $
  Vì $x_1^2>=0$, $8x_2^2>=0$ và mẫu số dương, nên $0<=t<=1$ và
  $
    1-t=frac(8x_2^2, x_1^2+8x_2^2).
  $
  Do đó,
  $
    frac(norm(x)_(7,9)^2, norm(x)_(1,8)^2) & =frac(7x_1^2+9x_2^2, x_1^2+8x_2^2) \
                                           & =7t+frac(9, 8)(1-t).
  $
  Vì $0<=t<=1$, biểu thức ở vế phải là trung bình có trọng số của $7$ và $9/8$, suy ra
  $
    frac(9, 8)
    <=frac(norm(x)_(7,9)^2, norm(x)_(1,8)^2)
    <=7.
  $
  Nhân với $norm(x)_(1,8)^2$ và lấy căn hai vế, ta thu được
  $
    frac(3, 2 sqrt(2))norm(x)_(1,8)
    <=norm(x)_(7,9)
    <=sqrt(7)norm(x)_(1,8).
  $
  Khi $x=0$, hai bất đẳng thức hiển nhiên đúng. Vì vậy hai chuẩn tương đương.
]

*Cách 4. Dùng định lý về không gian hữu hạn chiều.* Nếu đã biết định lý "mọi chuẩn trên một không gian vector hữu hạn chiều đều tương đương", thì câu a) cho thấy $norm(dot)_(1,8)$ và $norm(dot)_(7,9)$ đều là chuẩn trên $RR^2$. Vì $dim(RR^2)=2<o o$, suy ra ngay hai chuẩn tương đương. Cách này ngắn nhất nhưng không cho hằng số so sánh cụ thể và phụ thuộc vào định lý đã được chứng minh trước đó.

=== Kết quả tổng quát và kinh nghiệm lựa chọn phương pháp

Với $a,b,c,d>0$, đặt
$
  norm(x)_(a,b)=sqrt(a x_1^2+b x_2^2), quad
  norm(x)_(c,d)=sqrt(c x_1^2+d x_2^2).
$

Đặt
$
  m=sqrt(min(frac(c, a), frac(d, b))), quad
  M=sqrt(max(frac(c, a), frac(d, b))).
$

Vì $m^2a<=c<=M^2a$ và $m^2b<=d<=M^2b$, nhân tương ứng với $x_1^2$ và $x_2^2$ rồi cộng lại, ta được
$
  m^2(a x_1^2+b x_2^2)
  <=c x_1^2+d x_2^2
  <=M^2(a x_1^2+b x_2^2).
$

Lấy căn bậc hai,
$
  m norm(x)_(a,b)
  <=norm(x)_(c,d)
  <=M norm(x)_(a,b), quad forall x in RR^2.
$

Tóm lại, khi gặp bài toán tương tự:

- Nếu phải chứng minh một công thức là chuẩn, hãy tìm xem công thức có phải chuẩn quen thuộc sau một phép biến đổi tuyến tính đơn ánh hay không. Nếu không thuận tiện, kiểm tra ba tiên đề và dùng Cauchy–Schwarz cho bất đẳng thức tam giác.
- Nếu phải chứng minh hai chuẩn tương đương và đề cần hằng số cụ thể, hãy bình phương và so sánh từng hệ số. Nếu chỉ cần tính tương đương, chuẩn Euclid là một chuẩn trung gian đơn giản.
- Nếu đang làm việc trong không gian hữu hạn chiều và đã học định lý tương đương chuẩn, có thể áp dụng trực tiếp. Tuy nhiên, một chứng minh bằng bất đẳng thức thường chỉ ra rõ bản chất hơn.
#pagebreak()
== Tuần 2
#baitoan[Kiểm tra sự hội tụ của các dãy sau bằng định nghĩa trong không gian tương ứng:

  a) $x_k = (frac(2k, k+1), frac(1, k^2))$ trong $(RR^2, ||dot||_2)$.

  b) $x_k = (frac((-1)^k, k), 1 + frac(3, 2^k), frac(k+2, k^2+1))$ trong $(RR^3, ||dot||_infinity)$.

  c) $x_k = (frac(3k+1, 2k-1), frac(1, sqrt(k)))$ trong $(RR^2, ||dot||_1)$.

  d) $x_k = (frac(1, k), frac(1, k^2), dots, frac(1, k^n))$ trong $(RR^n, ||dot||_1)$.

  e) $x_k = (frac(sin(k^2), k) + frac(k, 2^k), sqrt(k^2+2k) - k)$ trong $(RR^2, ||dot||_infinity)$.

  f) $x_k = (frac(ln(k+1), k), (1+frac(1, k))^k, arctan(k))$ trong $(RR^3, ||dot||_2)$.
]
#loigiai[

  *a)* Ta kiểm tra $x_k ->(2,0)$ tribg $RR^2$ với chuẩn Euclid. Thật vậy, xét $d(x,y)=||x-y||_2$. Khi đó, ta chứng minh $lim_(k-> infinity) d(x_k,x)=0$. Với $x=(2,0)$, suy ra
  $
    d(x_k,x)=sqrt(((2 k)/(k+1)-2)^2+(1/k^2-0)) & =sqrt(((2k)/(k+1)-2)^2+1/k^4) \
                                               & =sqrt(((4)/(k+1))^2+1/k^4)<=2/(k+1)+1/k^2<=3/k \
  $
  Hơn nữa, có $lim_(k-> infinity) 3/k=0$, nên theo định lý kẹp
  $
    0<=d(x_k,x)<=3/k => lim_(k->infinity) d(x_k,x)=0
  $
  *b)* Với chuẩn $||.||_infinity=max{|x_1|,|x_2|,|x_3|}$ trong $RR^3$. Đặt $d_(infinity)(x,y)=max_(1<=i<=3)|x_i-y_i|$. Với $x_k = (frac((-1)^k, k), 1 + frac(3, 2^k), frac(k+2, k^2+1))$ và $x=(0,1,0)$. Ta kiểm tra $lim_(k->infinity)d_(infinity)(x_k,x)=0$. Có
  $
    d_(infinity)(x_k,x)=max{abs((-1)^k/k),abs(3/2^k),abs((k+2)/(k^2+1))} =max{1/k,3/2^k,(k+2)/(k^2+1)}={u_1,u_2,u_3}
  $
  Với mỗi $i in {1,2,3}$ ta đều có $lim_(k->infinity) u_i (k)=0$. Nên ta luôn có $ lim_(k->infinity)d_(infinity) (x_k,x)=0 $

  *c)* Tương tự câu a), ta dự đoán $x_k ->(3/2,0)$. Với $(x_1,x_2)in RR^2$, thì $||x||_1=sum_(i=1)^2 |x_i|$. Do đó, với $d(x,y)=||x-y||_1=sum_(i=1)^2|x_i-y_i|$. Với $x=x_k=((3k+1)/(2k-1),1/sqrt(k))$ và $y=x=(3/2,0)$ thì $ d(x_k,x)=abs((3k+1)/(2k-1)-3/2)+abs(1/sqrt(k)-0)&=abs(5/(4k-2))+abs(1/(sqrt(k)))=5/2 abs(1/(2k-1))+abs(1/sqrt(k))=5/2(1/(2k-1))+1/sqrt(k). quad (forall k>=1). $
  Mặt khác, do $lim_(k->infinity) 5/2(1/(2k-1))=0$ và $lim_(k->infinity)(1/(sqrt(k)))=0$. Nên $ lim_(k->infinity)(5/2 (1/(2k-1))+1/sqrt(k))=0+0=0 $
  Vậy, $lim_(k-> infinity) d_1(x_k,x)=0$.

  *d)* Ta dự đoán $x_k -> (0,0,..,0)=x in RR^n$. Khi đó, tương tự ý c), có $ d(x_k,x)=sum_(i=1)^n abs(x_k ( i)-x_i)= abs(1/k)+abs(1/(k^2))+...abs(1/(k^n))=sum_(i=1)^n abs(1/k^i)=sum_(i=1)^n 1/(k^i). $
  Mặt khác, với mỗi $i in{1,2,...,n}$ thì $lim_(k ->infinity) 1/k^i=0$. Nên
  $
    lim_(k->infinity) sum_(i=1)^n 1/(k^i)=0+0+...0=0
  $
  Vậy, $x_k -> x$.

  *e)* Ta dự đoán $x_k -> x=(0,1)$. Thật vậy, có $lim_(k->infinity) sin(k^2)/k=0$, do $forall k>=1, -1<=sin(k^2)<=1 <=> -1/k<=(sin (k^2))/k <=1/k$. Do đó, theo nguyên lý kẹp, thì $lim_(k->infinity) (sin(k^2))/k=0$. Ta chứng minh $lim_(k->infinity) d_infinity (x_k,x)=0$. Thật vậy, có
  $
    d_2(x_k,x)=max_(1<=i<=2){ abs(sin(k^2)/(k^))+k/(2^k)-0),abs(sqrt(k^2+2 k)-k-1)}={u_1,u_2}
  $
  Do đó, với mỗi $i in {1,2}$ thì $lim_(k -> infinity) u_i (k) =0$. Do đó, $lim_(k -> infinity) d_(infinity)(x_k,x)=0$.

  *f)*


]
#baitoan[Kiểm tra các dãy $x_k$ sau có hội tụ về $x$ trong $RR^n$ với metric $d$ tương ứng không:

  a) $x_k = (frac(1, k), frac(1, k^2), dots, frac(1, k^n))$, $x=(0,0,dots,0)$, với

  $
    d(x,y) := cases(
      0 & "nếu " x=y,
      1 & "nếu " x != y.
    )
  $

  b) $x_k = (frac(1, k^2), frac(-3, k^2))$, $x=(0,0)$, với $n=2$ và

  $
    d(x,y) := cases(
      ||x-y||_2 & "nếu " "x,y" "và gốc tọa độ "O" thẳng hàng",
      ||x||_2 + ||y||_2 & "ngược lại".
    )
  $

  c) $x_k = (frac(1, k), 1+frac((-1)^k, k))$, $x=(0,1)$, với $n=2$ và

  $
    d(x,y) := cases(
      ||x-y||_2 & "nếu " "x,y" " và gốc tọa độ " O " thẳng hàng",
      ||x||_2 + ||y||_2 & "ngược lại".
    )
  $
]

#loigiai[

  *a)* Để chứng minh $x_k -> x$ với metric d tương ứng, ta chỉ ra $lim_(k->infinity) d(x_k,x)=0$. Mặt khác, ta luôn có $x_k !=x$, nên $d(x_k,x)=1$, do đó $x_k$ không hội tụ về $x$.

  *b)* Với $x_k=(1/k^2),-3/k^2)$ và $x=0$, thì ta luôn có $x_k,x,0$ thẳng hàng, do đó
  $
    d(x_k,x)=norm(x_k-x)_2=sqrt(10)/k^2 => k->infinity => d(x_k,x)=0
  $
  Do đó, $(x_k)$ hội tụ về $x$.

  *c)* Với $x_k$ xác định như trên thì $x_k,x,O$ không thể thằng hàng, do đó, theo định nghĩa metric thì
  $
    d(x_k,x)=sqrt(1/k^2+(1+(-1)^k/(k))^2)
    +1=> k ->infinity => d(x_k,x)=2!=0
  $
  Do đó, $x_k$ không hội tụ về $x$ theo metric d.
]
#baitoan[ Trong $C[0,1]$, xét sự hội tụ của dãy $(f_n)$ đến $f$ lần lượt với chuẩn

  $
    ||f|| = max_(0 <= x <= 1) |f(x)|
    quad "và" quad
    ||f||_2 = (integral_0^1 |f(x)|^2 dif x)^(1/2).
  $

  a)

  $
    f_n(x) := cases(
      2n x quad & x in [0, frac(1, 2n)],
      2-2n x quad & x in (frac(1, 2n), frac(1, n)],
      0 & x in (frac(1, n), 1],
    )
  $

  và $f=0$.

  b) $f_n(x)=e^(-n x^2)$ và $f=0$, cho biết công thức tích phân Gauss

  $
    integral_(-infinity)^(+infinity) e^(-x^2) dif x = sqrt(pi).
  $

  c)

  $
    f_n (x) = sum_(k=1)^n frac(sin(k x), k^2+x)
  $

  và

  $
    f(x) = sum_(k=1)^infinity frac(sin(k x), k^2+x).
  $

]
#loigiai[

  Với $norm(f)=max_(0<=x<=1) |f(x)|$, khi đó ta đặt $d(f,g)=norm(f-g)$, dễ dàng kiểm chứng được $d$ là một metric trên $C[0,1]$. Ta chứng minh $(f_n) -> f <=> lim_(n->infinity) d(f_n,f)=0$. Thật vậy, có
  $
    d(f_n,f)=max_(0<=x<=1) abs(f_n (x)-f(x))=max_(0<=x<=1) abs(f_n)=max_(0<=x<=1){ abs(2n x),abs(2-2n x),0}=1 "Tại x=1/2"
  $
  Do đó, $lim_(n ->infinity) d(f_n,f)=1 !=0$, nên $(f_n)$ không hội tụ về $f$ với $norm(f)$.

  Với $norm(f)_2=(integral_0^1(f(x))^2dif x)^(1/2). => norm(f)_2^2=integral_0^1 (f(x))^2 dif x$.

  Do đó, tương tự ý trên , đặt $d(f,g)=norm(f-g)_2$. Thì ta có $d$ là một metric, hơn nữa $ d(f_n,f)=norm(f_n-f)=norm(f_n)_2 $ mà $ norm(f_n)_2^2=integral_0^(1/(2n)) (2n x)^2 dif x+integral_(1/(2n))^(1/n)(2- 2n x)^2 dif x=1/(6 n)+ 1/(6 n)=1/(3 n) => norm(f_n)_2=1/sqrt(3)=> n->infinity => d(f_n,f)=0 $
  Vậy $(f_n)$ hội tụ về $f$ theo chuẩn $norm(.)_2$.

  *b)*Ta có $f_n(x) = e^(-n x^2)$ và $f(x) = 0$ với mọi $x in [0, 1]$.

  *1. Xét sự hội tụ theo chuẩn $norm(.)$.*

  Ta có
  $
    norm(f_n - f) & = max_(0 <= x <= 1) abs(f_n(x) - f(x)) \
                  & = max_(0 <= x <= 1) e^(-n x^2).
  $

  Vì $n x^2 >= 0$ với mọi $x in [0, 1]$ nên
  $
    e^(-n x^2) <= 1.
  $
  Dấu bằng xảy ra khi $x = 0$. Do đó,
  $
    norm(f_n - f) = 1, quad forall n >= 1.
  $

  Suy ra
  $
    lim_(n -> infinity) norm(f_n - f) = 1 != 0.
  $

  Vậy dãy $(f_n)$ *không hội tụ* đến $f = 0$ theo chuẩn $norm(.)$.

  *2. Xét sự hội tụ theo chuẩn $norm(.)_2$.*

  Ta có
  $
    norm(f_n - f)_2^2 & = integral_0^1 abs(f_n(x) - f(x))^2 dif x \
                      & = integral_0^1 e^(-2 n x^2) dif x.
  $

  Do $e^(-2 n x^2) >= 0$ với mọi $x in [0, 1]$ nên
  $
    0 <= integral_0^1 e^(-2 n x^2) dif x
    <= integral_0^infinity e^(-2 n x^2) dif x.
  $

  Đặt $u = sqrt(2 n) x$, suy ra $dif x = 1/sqrt(2 n) dif u$.

  Khi đó,
  $
    integral_0^infinity e^(-2 n x^2) dif x & = 1/sqrt(2 n) integral_0^infinity e^(-u^2) dif u \
                                           & = 1/(2 sqrt(2 n)) integral_(-infinity)^infinity e^(-u^2) dif u \
                                           & = sqrt(pi)/(2 sqrt(2 n)).
  $

  Như vậy,
  $
    0 <= norm(f_n - f)_2^2
    <= sqrt(pi)/(2 sqrt(2 n)).
  $

  Mặt khác,
  $
    lim_(n -> infinity) sqrt(pi)/(2 sqrt(2 n)) = 0.
  $

  Theo định lý kẹp, ta có
  $
    lim_(n -> infinity) norm(f_n - f)_2^2 = 0.
  $

  Suy ra
  $
    lim_(n -> infinity) norm(f_n - f)_2 = 0.
  $

  Vậy dãy $(f_n)$ *hội tụ* đến $f = 0$ theo chuẩn $norm(.)_2$.
  $
    cases(
      f_n arrow.not f " theo chuẩn " norm(.),
      f_n -> f " theo chuẩn " norm(.)_2.
    )
  $
  *c)*

  *1. Xét sự hội tụ theo chuẩn $norm(.)$.*

  Với mọi $x in [0,1]$, ta có
  $
    abs(f_n(x) - f(x)) & = abs(sum_(k=n+1)^infinity sin(k x)/(k^2+x)) \
                       & <= sum_(k=n+1)^infinity abs(sin(k x))/(k^2+x) \
                       & <= sum_(k=n+1)^infinity 1/k^2.
  $

  Do đó,
  $
    0 <= norm(f_n-f)
    <= sum_(k=n+1)^infinity 1/k^2.
  $

  Mặt khác, vì hàm $1/x^2$ giảm trên $(0,+infinity)$ nên
  $
    sum_(k=n+1)^infinity 1/k^2
    <= integral_n^infinity 1/x^2 dif x
    = 1/n.
  $

  Suy ra
  $
    0 <= norm(f_n-f) <= 1/n.
  $

  Vì $lim_(n -> infinity) 1/n = 0$, theo định lý kẹp,
  $
    lim_(n -> infinity) norm(f_n-f) = 0.
  $

  Vậy $(f_n)$ hội tụ đến $f$ theo chuẩn $norm(.)$.

  *2. Xét sự hội tụ theo chuẩn $norm(.)_2$.*

  Ta có
  $
    norm(f_n-f)_2^2 & = integral_0^1 abs(f_n(x)-f(x))^2 dif x \
                    & <= integral_0^1 norm(f_n-f)^2 dif x \
                    & = norm(f_n-f)^2.
  $

  Do đó,
  $
    0 <= norm(f_n-f)_2 <= norm(f_n-f) <= 1/n.
  $

  Theo định lý kẹp,
  $
    lim_(n -> infinity) norm(f_n-f)_2 = 0.
  $

  Vậy $(f_n)$ hội tụ đến $f$ theo chuẩn $norm(.)_2$.


  Dãy $(f_n)$ hội tụ đến $f$ theo cả hai chuẩn
  $norm(.)$ và $norm(.)_2$.
]
#baitoan[ Cho $E$ là một không gian vector trên $RR$ và $||dot||_1$ và $||dot||_2$ là hai chuẩn tương đương trên $E$. Cho $(x_n)$ là một dãy bất kỳ trong $E$. Chứng minh rằng $(x_n)$ hội tụ đối với chuẩn $||dot||_1$ khi và chỉ khi nó hội tụ đối với chuẩn $||dot||_2$.
]
*(=>)* Giả sử $(x_n)$ hội tụ với chuẩn $norm(.)_1$ ta chứng minh $(x_n)$ hội tụ với chuẩn $norm(.)_2$. Với bất kỳ $x,y in E$ ta định nghĩa metric sinh bởi $norm(.)_1$ là $d_1(x,y)=norm(x-y)_1$ và tương ứng với $norm(.)_2$, ta đặt $d_2(x,y)=norm(x-y)_2$. Dễ dàng kiểm chứng, $d_1,d_2$ là các metric trên $E$. Khi đó, gọi $x in E$, sao cho $(x_n) -> x$ theo metric $d_1$, khi đó $lim_(n->infinity) d_1(x_n,x)=0$, ta chứng minh $lim_(n->infinity) d_2(x_n,x)=0$.

Vì $norm(.)_1$ và $norm(.)_2$ tương đương trên $E$, nên suy ra $exists m,M>0$ sao cho
$
  m norm(.)_2<=norm(.)_1<=M norm(.)_2
$
Do đó, ta luôn có $0<= m norm(x_n-x)_2<=norm(x_n-x)_1 <=> 0<=m d_2(x_n,x)<=d_1(x_n,x) => n ->infinity => lim_(n-> infinity) d_2(x_n,x)=0 "nguyên lý kẹp"$.

Chứng minh tương tự, sử dụng $norm(.)_1 <= M norm(.)_2$.
#baitoan[ Cho $x_k=(x_k^1,x_k^2,dots,x_k^n)$ là một dãy trong $(RR^n, ||dot||_p)$, với $p in [1,infinity]$. Chứng minh rằng $x_k$ hội tụ về $x=(x^1,x^2,dots,x^n)$ khi và chỉ khi
  $
    forall j = 1, dots, n, quad lim_(k -> infinity) x_k^j = x^j.
  $
]
#loigiai[

  Xét $1 <= p < infinity$.

  *Chiều thuận ($=>$).*

  Giả sử $(x_k)$ hội tụ đến $x$ theo chuẩn $norm(.)_p$. Khi đó,
  $
    lim_(k -> infinity) norm(x_k - x)_p = 0.
  $

  Với mỗi $j in {1, dots, n}$, ta có
  $
    0 <= abs(x_k^j - x^j)^p & <= sum_(i=1)^n abs(x_k^i - x^i)^p \
                            & = norm(x_k - x)_p^p.
  $

  Mặt khác,
  $
    lim_(k -> infinity) norm(x_k - x)_p^p = 0.
  $

  Theo định lý kẹp, suy ra
  $
    lim_(k -> infinity) abs(x_k^j - x^j)^p = 0.
  $

  Do đó,
  $
    lim_(k -> infinity) x_k^j = x^j,
    quad forall j = 1, dots, n.
  $

  *Chiều ngược ($<=$).*

  Giả sử
  $
    lim_(k -> infinity) x_k^j = x^j,
    quad forall j = 1, dots, n.
  $

  Khi đó,
  $
    lim_(k -> infinity) abs(x_k^j - x^j)^p = 0,
    quad forall j = 1, dots, n.
  $

  Vì tổng có hữu hạn số hạng nên
  $
    lim_(k -> infinity) norm(x_k - x)_p^p & = lim_(k -> infinity)
                                            sum_(j=1)^n abs(x_k^j - x^j)^p \
                                          & = sum_(j=1)^n
                                            lim_(k -> infinity) abs(x_k^j - x^j)^p \
                                          & = 0.
  $

  Suy ra
  $
    lim_(k -> infinity) norm(x_k - x)_p = 0.
  $

  Vậy $(x_k)$ hội tụ đến $x$ theo chuẩn $norm(.)_p$.

  *Trường hợp $p = infinity$.*

  Ta có
  $
    norm(x_k - x)_infinity
    = max_(1 <= j <= n) abs(x_k^j - x^j).
  $

  *Chiều thuận ($=>$).*

  Giả sử $norm(x_k - x)_infinity -> 0$ khi $k -> infinity$.

  Với mọi $j = 1, dots, n$, ta có
  $
    0 <= abs(x_k^j - x^j)
    <= norm(x_k - x)_infinity.
  $

  Theo định lý kẹp,
  $
    lim_(k -> infinity) abs(x_k^j - x^j) = 0.
  $

  Suy ra
  $
    lim_(k -> infinity) x_k^j = x^j,
    quad forall j = 1, dots, n.
  $

  *Chiều ngược ($<=$).*

  Giả sử
  $
    lim_(k -> infinity) x_k^j = x^j,
    quad forall j = 1, dots, n.
  $

  Khi đó,
  $
    0 <= norm(x_k - x)_infinity & = max_(1 <= j <= n) abs(x_k^j - x^j) \
                                & <= sum_(j=1)^n abs(x_k^j - x^j).
  $

  Vì
  $
    lim_(k -> infinity)
    sum_(j=1)^n abs(x_k^j - x^j) = 0,
  $
  nên theo định lý kẹp,
  $
    lim_(k -> infinity) norm(x_k - x)_infinity = 0.
  $

  Vậy $(x_k)$ hội tụ đến $x$ theo chuẩn $norm(.)_infinity$.

  *Kết luận.*

  Với mọi $p in [1, infinity]$, ta có
  $
    x_k -> x " theo chuẩn " norm(.)_p
    quad <=> quad
    lim_(k -> infinity) x_k^j = x^j,
    quad forall j = 1, dots, n.
  $
]

#baitoan[
  Trên $RR^2$, cho
  $
    d(x,y) := cases(
      abs(x_2-y_2) & x_1 = y_1,
      abs(x_1) + abs(y_1) + abs(x_2-y_2) quad & x_1 != y_1
    )
  $
  với $x=(x_1,x_2), y=(y_1,y_2)$.

  a) Kiểm tra rằng $d$ là một metric trên $RR^2$.

  b) Kiểm tra sự hội tụ của dãy
  $a_k = (1/k, 1)$
  đối với metric Euclide và metric $d$.

  c) Kiểm tra tương tự cho dãy
  $b_k = (1+1/k, 1)$.
]

#loigiai[

  *a)* Ta kiểm tra ba tính chất của một metric, nghĩa là


  *i)* Lấy $x,y in RR^2$, khi đó nếu $x_1=y_1$ , thì $d(x,y)=abs(x_2-y_2)>=0$ và hơn nữa $d(x,y)=0 <=> x_2-y_2=0 <=> x_2=y_2 <=> (x_1,y_1)=(x_2,y_2) <=> x=y$.

  Nếu $x_1 != y_1$, thì $d(x,y)= abs(x_1)+abs(y_1)+abs(x_2-y_2)>=0$, nếu $d(x,y)=0 <=> x_1=y_1=0$, mâu thuẫn, do đó $d(x,y) >0$ với $x!=y$.

  *ii)* Lấy $x,y in RR^2,x=(x_1,x_2),y=(y_1,y_2)$. Khi đó, nếu $x_1=y_1$ thì $d(x,y)=abs(x_2-y_2)=d(y,x)$ và nếu $x_1!=y_1$, thì $d(x,y)=abs(x_1)+abs(y_1)+abs(x_2-y_2)=abs(y_1)+abs(x_1)+abs(y_2-x_2)=d(y,x)$. Do đó, trong cả $2$ trường hợp thì $d(x,y)=d(y,x), forall x,y in RR^2$.

  *iii)* Lấy $x,y,z in RR^2$, khi đó nếu $x_1=y_1$, thì $d(x,y)=abs(x_2-y_2)$,khi đó với $z in RR^2$, nếu $z_1=x_1=y_1$, thì $d(x,z_1)=abs(x_2-z_2),d(y,z_1)=abs(y_2-z_2)$. Do đó, luôn có $d(x,y)<=d(x,z)+d(z,y) <=> abs(x_2-y_2)<=abs(x_2-z_2)+abs(z_2-y_2)$. Nếu $z_1!=y_1 => z_1 != x_1$. Do đó, $d(x,z)=abs(x_1)+abs(z_1)+abs(x_2-z_2)$ và $d(z,y)=abs(z_1)+abs(y_1)+abs(z_2-y_2)$. Mặt khác, có $d(x,y)=abs(x_2-y_2)<=abs(x_2-z_2)+abs(z_2-y_2)<=abs(x_1)+abs(z_1)+abs(x_2-z_2)+abs(z_1)+abs(y_1)+abs(z_2-y_2)=d(x,z)+d(y,z)$.

  Nếu $x_1!=y_1$, thì $d(x,y)=abs(x_1)+abs(y_1)+abs(x_2-y_2)$. Khi đó, với $z in RR^2$, nếu $z_1=y_1 =>z_1 !=x_1$, do đó có $d(x,z)=abs(x_1)+abs(z_1)+abs(x_2-z_2)$, $d(z,y)=abs(z_2-y_2)$. Mặt khác, $d(x,y)<=abs(x_1)+abs(y_1)+abs(x_2-z_2)+abs(z_2-y_2)=abs(x_1)+abs(z_1)+abs(x_2-z_2)+abs(z_2-y_2)=d(x,z)+d(z,y)$. Tương tự với, nếu $z_1=x_1 => z_1 !=y_1$. Mặt khác , nếu $z_1 != x_1$ và $z_1 != y_1$, thì ta có chứng minh ở ý trên.

  Vậy, từ (i),(ii),(iii) ta suy ra $d$ là một metric trên $RR^2$.

  *b)* Ta dự đoán, $a_k -> a=(0,1)$. Thật vậy, ta chứng minh $lim_(k->infinity) d(a_k,a)=0$. Với $d$ là metric Euclid, thì
  $
    d(a_k,a)=sqrt(1/k^2)=1/k => k->infinity => d(a_k,k)=0
  $
  Vậy, $a_k -> a$ theo metric Euclid.

  Hơn nữa, luôn có $1/k !=0, forall k>=1$. Do đó,
  $
    d(a_k,a)=abs(1/k)+abs(0)+abs(1-1)=abs(1/k)=1/k => k->infinity => d(a_k,a)=0
  $
  Do đó, $a_k -> a$ theo metric d.

  *c)* Ta dụ đoán $b_k -> b=(1,1)$. Thật vậy, với metric Euclid.

  $
    d(b_k,b)=sqrt(1/k^2)=1/k => k ->infinity => d(b_k,b)=0
  $
  Hơn nữa, luôn có $1+1/k != 1$, nên
  $
    d(b_k,b)=abs(1+1/k)+abs(1) => k ->infinity => d(b_k,b)=2 !=0
  $
  Do đó, $b_k$ không hội tụ về $b$ trong metric d.


]
#baitoan[ Cho không gian metric $(X,d)$ và $(x_n)$ là một dãy trong $X$. Chứng minh rằng $(x_n)$ hội tụ khi và chỉ khi mọi dãy con của nó hội tụ về cùng một giới hạn.
]
#loigiai[

  *=>)* Giả sử $(x_n)$ hội tụ về $x in X$. Ta chứng minh mọi dãy con của $(x_n)$ đều hội tụ về $x$. Thật vậy, lấy tùy ý dãy con của $(x_n)$, đặt $(x_(n_k) subset(x_n))$ thỏa $n_k>=k$. Ta chứng minh $(x_(n_k)-> x)$. Thật vậy, cho trước $epsilon>0$, tìm $K(epsilon) in NN$, sao cho, với $n in NN$ cho trước , nếu $n>= K(epsilon)$, thì cần $d(x_(n_k),x)<epsilon$.

  Từ giả thiết, với $x_n -> x$, thì với tùy ý $epsilon_1>0$, luôn có $N(epsilon_1) in NN$, sao cho với tùy ý $n in NN$, nếu $n>=N(epsilon_1)$ thì luôn có $d(x_n,x)<epsilon_1.$

  Mặt khác, có $d(x_(n_k),x)<=d(x_(n_k),x_n)+d(x_(n),x)$.

  Hơn nữa, do $(x_n)$ là dãy hội tụ , nên $(x_n)$ đặc biệt là dãy Cauchy. Suy ra, với bất kỳ $epsilon_2>0$, $exists N_2(epsilon_2) in NN$, sao cho $forall m,n in NN$, nếu $m,n>=N_2(epsilon_2)$ thì luôn có $d(x_n,x_m)<epsilon_2$. Do đó, xét $epsilon_2=epsilon_1=epsilon/2$ và chọn $K(epsilon)=max{N(epsilon_1),N_2(epsilon_2)}$ thì ta có điều phải chứng minh.

  *(<=)* Tương tự.
]

#baitoan[
  Trên $RR$, cho
  $
    d(x,y) := cases(
      0 & x = y,
      2^(max brace.l abs(x), abs(y) brace.r) quad & x != y.
    )
  $

  a) Kiểm tra rằng $d$ là một metric trên $RR$, đồng thời thỏa bất đẳng thức tam giác mạnh hơn:
  $
    d(x,y) <= max brace.l d(x,z), d(z,y) brace.r,
    quad x,y,z in RR.
  $
  Ánh xạ $d$ được gọi là một _ultrametric_ trên $RR$.

  b) Kiểm tra sự hội tụ của dãy
  $ {x_k = 1/k} $
  đối với metric Euclide và metric $d$.

  c) Tìm điều kiện để một dãy trong $(RR,d)$ là hội tụ.
]

Cho không gian metric $X$ và ánh xạ $x : NN -> X$. Nhắc lại rằng ta gọi $x = (x_n)$ là một dãy trong $X$. Cho $k : NN -> NN$ là một hàm tăng. Khi đó, ánh xạ $x ∘ k$ được gọi là một dãy con của $x$. Cũng như $x$, ta đồng nhất $x ∘ k$ với tập giá trị của nó
$
  x ∘ k & equiv (x(k(1)), x(k(2)), dots, x(k(n)), dots) \
        & = (x_(k(1)), x_(k(2)), dots, x_(k(n)), dots).
$

Nếu ta đặt $k_n := k(n)$ thì
$
  x ∘ k equiv (x_(k_1), x_(k_2), dots, x_(k_n), dots).
$

Từ nay về sau, ta sẽ ký hiệu $(x_(k_n))$ thay cho $x ∘ k$ như một dãy con của $(x_n)$.
#loigiai[


  Ta chứng minh $d$ thỏa mãn các tiên đề của metric.

  Với mọi $x, y in RR$, theo định nghĩa của $d$, ta có

  $
    d(x, y) >= 0.
  $

  Hơn nữa,

  $
    d(x, y) = 0 <=> x = y.
  $

  Mặt khác, vì

  $
    max(|x|, |y|) = max(|y|, |x|),
  $

  nên

  $
    d(x, y) = d(y, x),
    quad forall x, y in RR.
  $

  Ta chứng minh bất đẳng thức tam giác mạnh

  $
    d(x, y) <= max(d(x, z), d(z, y)),
    quad forall x, y, z in RR.
  $

  Xét các trường hợp sau:

  - *Trường hợp 1:* Nếu $x = y$, ta có

    $
      d(x, y) = 0
      <= max(d(x, z), d(z, y)).
    $

  - *Trường hợp 2:* Nếu $x != y$ và $z = x$ hoặc $z = y$, ta có

    $
      d(x, y) = max(d(x, z), d(z, y)).
    $

  - *Trường hợp 3:* Nếu $x, y, z$ đôi một khác nhau.

    Theo định nghĩa của giá trị lớn nhất, ta có

    $
      max(|x|, |y|)
      <= max(|x|, |y|, |z|).
    $

    Vì hàm số $f(t) = 2^t$ đồng biến trên $RR$, suy ra

    $
      2^(max(|x|, |y|))
      <= 2^(max(|x|, |y|, |z|)).
    $

    Mặt khác, ta có tính chất

    $
      max(a, b, c)
      = max(max(a, c), max(c, b)).
    $

    Đồng thời, do hàm số $f(t) = 2^t$ đồng biến nên

    $
      2^(max(a, b)) = max(2^a, 2^b).
    $

    Do đó,

    $
      d(x, y) & = 2^(max(|x|, |y|)) \
              & <= 2^(max(|x|, |y|, |z|)) \
              & = 2^(max(
                  max(|x|, |z|),
                  max(|z|, |y|)
                )) \
              & = max(
                  2^(max(|x|, |z|)),
                  2^(max(|z|, |y|))
                ) \
              & = max(d(x, z), d(z, y)).
    $

  Vậy trong mọi trường hợp,

  $
    d(x, y) <= max(d(x, z), d(z, y)).
  $

  Mặt khác, vì $d(x, z) >= 0$ và $d(z, y) >= 0$, nên

  $
    max(d(x, z), d(z, y))
    <= d(x, z) + d(z, y).
  $

  Suy ra

  $
    d(x, y) <= d(x, z) + d(z, y).
  $

  Vậy $d$ là một metric trên $RR$ và thỏa mãn bất đẳng thức tam giác mạnh, hay $d$ là một ultrametric trên $RR$.

  *Lời giải câu b).*

  Xét dãy $(x_k)$ với $x_k = 1/k$, $k in NN^+$.

  *Đối với metric Euclid.*

  Ta có

  $
    d_E(x_k, 0)
    = |1/k - 0|
    = 1/k.
  $

  Mà

  $
    lim_(k -> infinity) 1/k = 0,
  $

  nên

  $
    lim_(k -> infinity) d_E(x_k, 0) = 0.
  $

  Do đó, dãy $(x_k)$ hội tụ về $0$ đối với metric Euclid.

  *Đối với metric $d$.*

  Ta có $x_k != 0$ với mọi $k in NN^+$, nên

  $
    d(x_k, 0) & = 2^(max(|1/k|, |0|)) \
              & = 2^(1/k).
  $

  Suy ra

  $
    lim_(k -> infinity) d(x_k, 0)
    = lim_(k -> infinity) 2^(1/k)
    = 1 != 0.
  $

  Vậy $(x_k)$ không hội tụ về $0$ đối với metric $d$.

  Ta tiếp tục chứng minh $(x_k)$ không hội tụ về bất kỳ điểm nào trong $RR$.

  Giả sử tồn tại $a in RR$ sao cho $x_k -> a$ đối với metric $d$.

  Theo định nghĩa hội tụ, với mọi $epsilon > 0$, tồn tại $N in NN^+$ sao cho

  $
    forall k >= N:
    d(x_k, a) < epsilon.
  $

  Chọn $epsilon = 1 > 0$. Khi đó tồn tại $N in NN^+$ sao cho

  $
    forall k >= N:
    d(x_k, a) < 1.
  $

  Giả sử tồn tại $k >= N$ sao cho $x_k != a$. Khi đó,

  $
    d(x_k, a)
    = 2^(max(|x_k|, |a|))
    >= 2^0
    = 1,
  $

  mâu thuẫn với $d(x_k, a) < 1$.

  Do đó,

  $
    forall k >= N:
    x_k = a.
  $

  Điều này mâu thuẫn với việc các số hạng của dãy $x_k = 1/k$ đôi một khác nhau.

  Vậy dãy $(x_k)$ không hội tụ trong $(RR, d)$.

  *Lời giải câu c).*

  Ta chứng minh rằng một dãy $(x_n)$ trong $(RR, d)$ hội tụ về $x in RR$ khi và chỉ khi tồn tại $N in NN^+$ sao cho

  $
    forall n >= N:
    x_n = x.
  $

  Hay tương đương,

  $
    x_n -> x
    <=>
    exists N in NN^+,
    forall n >= N:
    x_n = x.
  $

  *Chiều thuận ($=>$).*

  Giả sử $(x_n)$ hội tụ về $x$ đối với metric $d$.

  Theo định nghĩa hội tụ, với mọi $epsilon > 0$, tồn tại $N in NN^+$ sao cho

  $
    forall n >= N:
    d(x_n, x) < epsilon.
  $

  Chọn $epsilon = 1 > 0$. Khi đó tồn tại $N in NN^+$ sao cho

  $
    forall n >= N:
    d(x_n, x) < 1.
  $

  Giả sử tồn tại $n >= N$ sao cho $x_n != x$.

  Khi đó,

  $
    d(x_n, x) & = 2^(max(|x_n|, |x|)) \
              & >= 2^0 \
              & = 1.
  $

  Điều này mâu thuẫn với $d(x_n, x) < 1$.

  Do đó,

  $
    exists N in NN^+,
    forall n >= N:
    x_n = x.
  $

  *Chiều đảo ($<=$).*

  Giả sử tồn tại $N in NN^+$ sao cho

  $
    forall n >= N:
    x_n = x.
  $

  Cho trước $epsilon > 0$.

  Với mọi $n >= N$, ta có

  $
    d(x_n, x) = d(x, x) = 0 < epsilon.
  $

  Theo định nghĩa hội tụ trong không gian metric, suy ra

  $
    x_n -> x
  $

  đối với metric $d$.

  Vậy ta có điều phải chứng minh.

  *Nhận xét.*

  Từ câu c), ta suy ra một dãy trong $(RR, d)$ hội tụ khi và chỉ khi dãy đó trở thành dãy hằng kể từ một chỉ số nào đó.

]
#baitoan[ Cho $(x_n)$ là một dãy trong không gian metric $(X,d)$. Chứng minh rằng $(x_n)$ hội tụ nếu và chỉ nếu các dãy con $(x_(2n))$, $(x_(2n+1))$ và $(x_(3n))$ hội tụ.
]
#loigiai[
  *($=>$).*

  Giả sử $(x_n)$ hội tụ đến $a in X$. Khi đó, mọi dãy con của $(x_n)$ đều hội tụ đến $a$.

  Do đó, các dãy con $(x_(2 n))$, $(x_(2 n+1))$ và $(x_(3 n))$ đều hội tụ.

  *(<=).*

  Giả sử các dãy con $(x_(2 n))$, $(x_(2 n+1))$ và $(x_(3 n))$ đều hội tụ.

  Khi đó, tồn tại $a,b,c in X$ sao cho
  $
    lim_(n -> infinity) x_(2 n) = a, quad
    lim_(n -> infinity) x_(2 n+1) = b,
  $
  $
    lim_(n -> infinity) x_(3 n) = c.
  $

  Nhận thấy $(x_(6 n))$ là dãy con của cả $(x_(2 n))$ và $(x_(3 n))$. Do đó,
  $
    lim_(n -> infinity) x_(6 n) = a,
    quad
    lim_(n -> infinity) x_(6 n) = c.
  $

  Theo tính duy nhất của giới hạn trong không gian metric, suy ra $a=c$.

  Tương tự, $(x_(6 n+3))$ là dãy con của cả $(x_(2 n+1))$ và $(x_(3 n))$, nên
  $
    lim_(n -> infinity) x_(6 n+3) = b,
    quad
    lim_(n -> infinity) x_(6 n+3) = c.
  $

  Suy ra $b=c$. Vậy $a=b=c$.

  Ta chứng minh $(x_n)$ hội tụ đến $a$.

  Cho trước $epsilon > 0$.

  Vì $x_(2 n) -> a$, nên tồn tại $N_1 in NN$ sao cho
  $
    forall n >= N_1,
    quad d(x_(2 n),a) < epsilon.
  $

  Tương tự, vì $x_(2 n+1) -> a$, nên tồn tại $N_2 in NN$ sao cho
  $
    forall n >= N_2,
    quad d(x_(2 n+1),a) < epsilon.
  $

  Chọn
  $
    N = max brace.l 2 N_1, 2 N_2 + 1 brace.r.
  $

  Với mọi $k >= N$, ta xét hai trường hợp:

  - Nếu $k = 2 m$ thì $m >= N_1$. Do đó,
    $d(x_k,a) = d(x_(2 m),a) < epsilon$.

  - Nếu $k = 2 m+1$ thì $m >= N_2$. Do đó,
    $d(x_k,a) = d(x_(2 m+1),a) < epsilon$.

  Như vậy,
  $
    forall epsilon > 0,
    exists N in NN,
    forall k >= N:
    d(x_k,a) < epsilon.
  $

  Theo định nghĩa hội tụ trong không gian metric, suy ra
  $
    lim_(k -> infinity) x_k = a.
  $

  Vậy $(x_n)$ hội tụ.

]
#baitoan[ Cho $cal(B)(D,RR)$ là tập hợp các hàm số bị chặn trên tập khác rỗng $D$. Ta biết rằng ánh xạ

  $
    ||dot|| : cal(B)(D,RR) -> RR
  $

  $
    f arrow.r ||f|| = sup_(x in D) |f(x)|
  $

  xác định một chuẩn trên $cal(B)(D,RR)$, thường được gọi là chuẩn _sup_. Nếu một dãy $(f_n)$ trong $cal(B)(D,RR)$ hội tụ theo chuẩn _sup_ thì ta nói $(f_n)$ hội tụ đều. Chứng minh rằng:

  a) Nếu $(f_n)$ và $(g_n)$ là hai dãy hàm hội tụ đều trên $D$ thì $(f_n+g_n)$ cũng hội tụ đều trên $D$.

  b) Hơn nữa, nếu $(f_n)$ và $(g_n)$ là hai dãy hàm bị chặn thì $(f_n g_n)$ cũng hội tụ đều trên $D$.

  c) Chứng minh rằng sự hội tụ đều dẫn đến sự hội tụ điểm. Nghĩa là, nếu $(f_n)$ hội tụ đều đến $f$ trong $cal(B)(D,RR)$ thì

  $
    forall x in D, quad lim_(n -> infinity) f_n(x) = f(x).
  $

  Chiều ngược lại có đúng không?

]
#loigiai[
  Với chuẩn sup như trên, ta đặt ánh xạ $d : cal(B(D,RR)) times cal(B(D,R))-> [0,infinity)$, với $d(f,g)=norm(f-g)=sup_(x in D)abs(f(x)-g(x))$. Dễ dàng chứng minh được $d$ là một metric.

  *a)* Giả sử $f_(n) -> f$ và $g_(n) -> g$, ta chứng minh $(f_n+g_n)$ hội tụ. Vì $f_n -> f$, nên $lim_(n-> infinity) d(f_n,f)=0$, và $ d(f_n,f)=sup_(x in D) abs(f_n (x)-f(x)), n->infinity => d(f_n,f) ->0 $
  Tương tự, với $g_n$. Vậy ta chứng minh $lim_(n->infinity)d(f_n+g_n,f+g)=0$. Thật vậy,
  $
    d(f_n+g_n,f+g)=sup_(x in D) abs(f_n (x)+g_n (x)-f(x)-g(x))<=sup_(x in D) abs(f_n (x)-f(x))+sup_(x in D) abs(g_n (x)-g(x)).
  $
  Khi đó, với $n->infinity$, thì $d(f_n,f)+d(g_n,g) -> 0 => d(f_n+g_n,f+g) -> 0$. Do đó, $(f_n+g_n)$ hội tụ đều.

  *b) Xét sự hội tụ đều của dãy tích $(f_n g_n)$.*

  Nếu chỉ giả sử $(f_n)$ và $(g_n)$ là hai dãy hàm bị chặn thì chưa đủ để kết luận $(f_n g_n)$ hội tụ đều trên $D$.

  Thật vậy, xét $f_n(x) = (-1)^n$ và $g_n(x) = 1$ với mọi $x in D$. Khi đó, $(f_n)$ và $(g_n)$ đều là các dãy hàm bị chặn, nhưng $f_n (x) g_n (x) = (-1)^n$ không hội tụ.

  Do đó, ta cần bổ sung giả thiết $(f_n)$ và $(g_n)$ đều hội tụ đều trên $D$.

  Giả sử $f_n -> f$ và $g_n -> g$ theo chuẩn sup, trong đó $f, g in cal(B)(D, RR)$.

  Vì $(f_n)$ hội tụ đều đến $f$ và các hàm $f_n$ đều bị chặn nên tồn tại $M > 0$ sao cho
  $
    |f_n(x)| <= M,
    quad forall n in NN, forall x in D.
  $

  Mặt khác, vì $g in cal(B)(D, RR)$ nên tồn tại $K > 0$ sao cho
  $
    |g(x)| <= K, quad forall x in D.
  $

  Cho trước $epsilon > 0$. Vì $(g_n)$ hội tụ đều đến $g$ nên tồn tại $N_1(epsilon) in NN$ sao cho
  $
    forall n >= N_1(epsilon), forall x in D:
    |g_n(x) - g(x)| < epsilon / (2 M).
  $

  Tương tự, vì $(f_n)$ hội tụ đều đến $f$ nên tồn tại $N_2(epsilon) in NN$ sao cho
  $
    forall n >= N_2(epsilon), forall x in D:
    |f_n(x) - f(x)| < epsilon / (2 K).
  $

  Đặt
  $
    N(epsilon) = max(N_1(epsilon), N_2(epsilon)).
  $

  Với mọi $n >= N(epsilon)$ và mọi $x in D$, theo bất đẳng thức tam giác, ta có
  $
    & |f_n(x) g_n(x) - f(x) g(x)| \
    & = |f_n(x)(g_n(x) - g(x)) + g(x)(f_n(x) - f(x))| \
    & <= |f_n(x)| |g_n(x) - g(x)|
      + |g(x)| |f_n(x) - f(x)| \
    & < M epsilon / (2 M) + K epsilon / (2 K) \
    & = epsilon.
  $

  Vậy, theo định nghĩa, $(f_n g_n)$ hội tụ đều đến $f g$ trên $D$.
  *Chứng minh $cal(B)(D, RR)$ là không gian metric đầy đủ.*

  Xét không gian $cal(B)(D, RR)$ với metric sinh bởi chuẩn sup:
  $
    d(f,g) = norm(f-g)_infinity
    = sup_(x in D) |f(x)-g(x)|.
  $

  Lấy $(f_n) subset cal(B)(D, RR)$ là một dãy Cauchy bất kỳ. Ta cần tìm $f in cal(B)(D, RR)$ sao cho $(f_n)$ hội tụ đến $f$ theo metric $d$.

  Vì $(f_n)$ là dãy Cauchy nên với mọi $epsilon > 0$, tồn tại $N(epsilon) in NN$ sao cho với mọi $m,n >= N(epsilon)$, ta có
  $
    d(f_n,f_m) < epsilon.
  $

  Theo định nghĩa của metric $d$, với mọi $x in D$,
  $
    |f_n(x)-f_m(x)|
    <= sup_(t in D) |f_n(t)-f_m(t)|
    < epsilon. quad (1)
  $

  Do đó, với mỗi $x in D$, dãy số $(f_n(x))$ là dãy Cauchy trong $RR$.

  Vì $(RR,d_(t t))$ là không gian metric đầy đủ nên với mỗi $x in D$, tồn tại duy nhất $f(x) in RR$ sao cho
  $
    lim_(n -> infinity) f_n(x) = f(x).
  $

  Như vậy, ta xây dựng được ánh xạ
  $
    f: D -> RR,
    quad x |-> f(x).
  $

  *Ta chứng minh $(f_n)$ hội tụ đều đến $f$ trên $D$.*

  Cho trước $epsilon > 0$.

  Vì $(f_n)$ là dãy Cauchy theo chuẩn sup nên tồn tại $N(epsilon) in NN$ sao cho với mọi $m,n >= N(epsilon)$ và mọi $x in D$, ta có
  $
    |f_n(x)-f_m(x)| < epsilon/2. quad (2)
  $

  Mặt khác, với mỗi $x in D$, ta đã có
  $
    lim_(m -> infinity) f_m(x) = f(x).
  $

  Do đó, theo định nghĩa giới hạn trong $RR$, với mỗi $x in D$, tồn tại $N_1(epsilon,x) in NN$ sao cho
  $
    forall m >= N_1(epsilon,x):
    |f_m(x)-f(x)| < epsilon/2. quad (3)
  $

  Lấy tùy ý $n >= N(epsilon)$ và $x in D$.

  Chọn
  $
    m >= max(N(epsilon), N_1(epsilon,x)).
  $

  Khi đó, từ (2), (3) và bất đẳng thức tam giác, ta được
  $
    & |f_n(x)-f(x)| \
    & = |f_n(x)-f_m(x)+f_m(x)-f(x)| \
    & <= |f_n(x)-f_m(x)|+|f_m(x)-f(x)| \
    & < epsilon/2+epsilon/2 \
    & = epsilon.
  $

  Như vậy, ta đã chứng minh
  $
    forall epsilon > 0, exists N(epsilon) in NN,
    forall n >= N(epsilon), forall x in D:
    |f_n(x)-f(x)| < epsilon.
  $

  Theo định nghĩa, $(f_n)$ hội tụ đều đến $f$ trên $D$.

  *Ta chứng minh $f in cal(B)(D, RR)$.*

  Chọn $epsilon = 1$. Theo kết quả vừa chứng minh, tồn tại $N_0 in NN$ sao cho
  $
    forall x in D:
    |f_(N_0)(x)-f(x)| < 1.
  $

  Vì $f_(N_0) in cal(B)(D, RR)$ nên tồn tại $M > 0$ sao cho
  $
    forall x in D: |f_(N_0)(x)| <= M.
  $

  Với mọi $x in D$, sử dụng bất đẳng thức tam giác, ta có
  $
    & |f(x)| \
    & = |f(x)-f_(N_0)(x)+f_(N_0)(x)| \
    & <= |f(x)-f_(N_0)(x)|+|f_(N_0)(x)| \
    & < 1+M.
  $

  Do đó, $f$ bị chặn trên $D$, hay
  $
    f in cal(B)(D, RR).
  $

  Mặt khác, vì $(f_n)$ hội tụ đều đến $f$ trên $D$ nên với mọi $epsilon > 0$, tồn tại $N(epsilon) in NN$ sao cho với mọi $n >= N(epsilon)$,
  $
    d(f_n,f)
    = sup_(x in D) |f_n(x)-f(x)|
    <= epsilon/2 < epsilon.
  $

  Vậy, mọi dãy Cauchy trong $cal(B)(D, RR)$ đều hội tụ đến một phần tử thuộc $cal(B)(D, RR)$

  *c)*

  Giả sử $(f_n)$ hội tụ đều đến $f$ trên $D$. Ta chứng minh $(f_n)$ hội tụ điểm đến $f$ trên $D$.

  Vì $f_n -> f$ theo chuẩn sup nên
  $
    lim_(n -> infinity) d(f_n,f) = 0.
  $

  Mặt khác, với bất kỳ $x in D$, ta luôn có
  $
    0 <= |f_n(x)-f(x)|
    <= sup_(t in D) |f_n(t)-f(t)|
    = d(f_n,f).
  $

  Khi đó, vì $lim_(n -> infinity) d(f_n,f) = 0$ nên theo định lý kẹp, ta có
  $
    lim_(n -> infinity) |f_n(x)-f(x)| = 0.
  $

  Hay
  $
    lim_(n -> infinity) f_n(x) = f(x),
    quad forall x in D.
  $

  Do đó, $(f_n)$ hội tụ điểm đến $f$ trên $D$.

  *Chiều ngược lại có đúng không?*

  Chiều ngược lại không đúng.

  Thật vậy, xét $D = [0,1]$ và dãy hàm $(f_n)$ được xác định bởi
  $
    f_n(x) = x^n, quad forall x in [0,1].
  $

  Với mọi $x in [0,1)$, ta có
  $
    lim_(n -> infinity) x^n = 0.
  $

  Mặt khác, tại $x=1$, ta có
  $
    lim_(n -> infinity) f_n(1) = 1.
  $

  Do đó, $(f_n)$ hội tụ điểm đến hàm $f$ được xác định bởi
  $
    f(x) = cases(
      0 & "nếu" 0 <= x < 1,
      1 & "nếu" x = 1.
    )
  $

  Tuy nhiên, với mọi $n in NN$, ta có
  $
    d(f_n,f)
    = sup_(x in [0,1]) |f_n(x)-f(x)|
    = sup_(x in [0,1)) x^n
    = 1.
  $

  Suy ra
  $
    lim_(n -> infinity) d(f_n,f) = 1 != 0.
  $

  Vậy $(f_n)$ không hội tụ đều đến $f$ trên $D$.
]
#baitoan[ Trong $RR^n$, một dãy $(x_k)$ gọi là _hội tụ yếu_ đến $x$, ký hiệu

  $
    x_k harpoon.rt x,
  $

  nếu với mọi phiếm hàm tuyến tính $f: RR^n -> RR$, ta có $f(x_k) -> f(x)$.

  Khi này, để phân biệt, người ta còn gọi sự hội tụ theo chuẩn là _hội tụ mạnh_. Chứng minh rằng, trên $(RR^n, ||dot||_p)$, $p in [1,infinity]$, hội tụ yếu tương đương với hội tụ mạnh. Cụ thể hơn,

  $
    (x_k harpoon.rt x) <=> (x -> x).
  $

]
#loigiai[
  Ta chứng minh

  $
    x_k harpoon.rt x <=> norm(x_k - x)_p -> 0.
  $

  *Chiều thuận ($=>$).*

  Giả sử $x_k harpoon.rt x$.

  Theo định nghĩa hội tụ yếu, với mọi phiếm hàm tuyến tính $f: RR^n -> RR$, ta có

  $
    f(x_k) -> f(x).
  $

  Đặt

  $
    x_k = (x_k^1, x_k^2, dots, x_k^n),
    quad x = (x^1, x^2, dots, x^n).
  $

  Với mỗi $i in {1, 2, dots, n}$, xét ánh xạ

  $
    f_i: RR^n -> RR,
    quad f_i (y) = y^i.
  $

  Ta có $f_i$ là phiếm hàm tuyến tính trên $RR^n$.

  Do giả thiết $x_k harpoon.rt x$, suy ra

  $
    f_i (x_k) -> f_i(x).
  $

  Hay

  $
    x_k^i -> x^i,
    quad forall i in {1, 2, dots, n}.
  $

  Do đó,

  $
    lim_(k -> infinity) |x_k^i - x^i| = 0,
    quad forall i in {1, 2, dots, n}.
  $

  Ta xét hai trường hợp.

  *Trường hợp 1:* $1 <= p < infinity$.

  Cho trước $epsilon > 0$.

  Với mỗi $i in {1, 2, dots, n}$, vì $x_k^i -> x^i$, tồn tại $N_i in NN^+$ sao cho

  $
    forall k >= N_i:
    |x_k^i - x^i| < epsilon / n^(1/p).
  $

  Đặt

  $
    N = max(N_1, N_2, dots, N_n).
  $

  Khi đó, với mọi $k >= N$, ta có

  $
    norm(x_k - x)_p & = (sum_(i=1)^n |x_k^i - x^i|^p)^(1/p) \
                    & < (sum_(i=1)^n (epsilon / n^(1/p))^p)^(1/p) \
                    & = (n epsilon^p / n)^(1/p) \
                    & = epsilon.
  $

  Suy ra

  $
    lim_(k -> infinity) norm(x_k - x)_p = 0.
  $

  *Trường hợp 2:* $p = infinity$.

  Cho trước $epsilon > 0$.

  Vì $x_k^i -> x^i$ với mọi $i in {1, 2, dots, n}$, nên với mỗi $i$ tồn tại $N_i in NN^+$ sao cho

  $
    forall k >= N_i:
    |x_k^i - x^i| < epsilon.
  $

  Đặt $N = max(N_1, N_2, dots, N_n)$.

  Khi đó, với mọi $k >= N$, ta có

  $
    norm(x_k - x)_infinity & = max_(1 <= i <= n) |x_k^i - x^i| \
                           & < epsilon.
  $

  Suy ra

  $
    lim_(k -> infinity) norm(x_k - x)_infinity = 0.
  $

  Vậy trong mọi trường hợp, $x_k -> x$ theo chuẩn $norm(.)_p$.

  *Chiều đảo ($<=$).*

  Giả sử $x_k -> x$ theo chuẩn $norm(.)_p$, tức là

  $
    lim_(k -> infinity) norm(x_k - x)_p = 0.
  $

  Ta cần chứng minh với mọi phiếm hàm tuyến tính $f: RR^n -> RR$, ta có

  $
    f(x_k) -> f(x).
  $

  Lấy tùy ý một phiếm hàm tuyến tính $f: RR^n -> RR$.

  Gọi $e_1, e_2, dots, e_n$ là cơ sở chính tắc của $RR^n$.

  Ta có

  $
    x_k - x = sum_(i=1)^n (x_k^i - x^i) e_i.
  $

  Do $f$ tuyến tính, suy ra

  $
    f(x_k) - f(x) & = f(x_k - x) \
                  & = f(sum_(i=1)^n (x_k^i - x^i) e_i) \
                  & = sum_(i=1)^n (x_k^i - x^i) f(e_i).
  $

  Do đó, theo bất đẳng thức tam giác,

  $
    |f(x_k) - f(x)| & <= sum_(i=1)^n |x_k^i - x^i| |f(e_i)|.
  $

  Mặt khác, với mọi $p in [1, infinity]$, ta luôn có

  $
    |x_k^i - x^i| <= norm(x_k - x)_p.
  $

  Suy ra

  $
    |f(x_k) - f(x)| & <= sum_(i=1)^n |f(e_i)| norm(x_k - x)_p \
                    & = (sum_(i=1)^n |f(e_i)|) norm(x_k - x)_p.
  $

  Vì $f$ đã được cố định nên

  $
    C = sum_(i=1)^n |f(e_i)| >= 0
  $

  là một hằng số không phụ thuộc vào $k$.

  Do

  $
    lim_(k -> infinity) norm(x_k - x)_p = 0,
  $

  nên theo định lý kẹp,

  $
    lim_(k -> infinity) |f(x_k) - f(x)| = 0.
  $

  Suy ra

  $
    f(x_k) -> f(x).
  $

  Vì $f$ là phiếm hàm tuyến tính tùy ý, theo định nghĩa hội tụ yếu, ta có

  $
    x_k harpoon.rt x.
  $

  Vậy ta có điều phải chứng minh:

  $
    x_k harpoon.rt x <=> x_k -> x.
  $
]
#pagebreak()

= Đề Thi Giữa Kỳ
== 2025-2026 -- Nguyễn Đăng Khoa

#cau[ Cho $E = RR^2$. Với $a,b > 0$ cho trước, ta xét ánh xạ:

  $ ||.||_(a,b): E -> RR $

  $ x ↦ ||x||_(a,b) = ||(x_1,x_2)||_(a,b) = sqrt(a x_1^2 + b x_2^2) $

  (a) Chứng minh rằng với mọi $a,b > 0$, ta có $(E, ||.||_(a,b))$ là không gian định chuẩn.

  (b) Chứng minh rằng $||.||_(1,8)$ và $||.||_(7,9)$ là hai chuẩn tương đương.
]

#cau[ Cho $E = RR^2$. Với $a,b > 0$ cho trước, ta xét ánh metric:

  $ delta_(a,b): E times E -> RR $

  $ (x,y) ↦ delta_(a,b)(x,y) = ||x-y||_(a,b) $

  trong đó $||.||_(a,b)$ là chuẩn như đã cho ở *Câu 1*. Với $u in RR^2$ và $r > 0$, ta ký hiệu:

  $ bb(B)_(a,b)(u,r) = brace.l z in E : delta_(a,b)(z,u) < r brace.r $

  (a) Cho $u = (0,0)$ và $r = 5$. Hỏi các phát biểu sau là đúng hay sai? Hãy chứng minh chi tiết khẳng định của mình:

  #pad(left: 1.2em)[
    (i) $bb(B)_(2,3)(u,r) subset bb(B)_(4,6)(u,r)$

    (ii) $bb(B)_(4,6)(u,r) subset bb(B)_(2,3)(u,r)$
  ]

  (b) Chứng minh rằng với mọi $a,b > 0$, không gian $(E, delta_(a,b))$ là không gian metric đầy đủ.
]

#cau[ Cho $E = C([a,b])$, $F = RR$ và các metric sau:

  $ delta_E: E times E -> RR $

  $ (x,y) ↦ delta_E(x,y) = sup_(t in [a,b]) |x(t) - y(t)| $

  $ delta_F: F times F -> RR $

  $ (f,g) ↦ delta_F(f,g) = |f-g| $

  (a) Xét ánh xạ

  $ f: E -> F $

  $ x ↦ f(x) = integral_a^b (x(t) + 1/2 x^2(t)) dif t $

  Chứng minh rằng $f$ liên tục trên $E$.

  (b) Giả sử rằng $g: E -> F$ và $h: E -> F$ là hai ánh xạ liên tục đều trên $E$. Chứng minh rằng với mọi $alpha in RR$, ánh xạ $g + alpha h$ cũng liên tục đều trên $E$.

]
#cau[ Cho $D = [0,2]$ và dãy hàm:

  $ f_n: D -> RR $

  $ x ↦ f_n (x) = |x-1|^n $

  Chứng minh rằng:

  (a) Dãy hàm $(f_n)$ hội tụ điểm về một hàm $f$ trên $D$. Hãy chỉ ra cụ thể hàm $f$ này.

  (b) Dãy hàm $(f_n)$ không hội tụ đều về hàm $f$ đã chỉ ra trên $D$.

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

  *a)*

  *(i)* Lấy $x in E=RR^2, x=(x_1,x_2)$. Với $a,b>0$, có $norm(x)_(a,b)=sqrt(a x_1^2 + b x_2^2) => norm(x)>=0$ và $norm(x)_(a,b)=0 <=> sqrt(a x_1^2 +b x_2^2) =0 <=> x_1=x_2=0 "do" a,b>0$.

  *(ii)* Lấy $x in E$ và $alpha in RR$, ta có $alpha x=(alpha x_1, alpha x_2)$, do đó
  $
    norm(alpha x)=sqrt(a (alpha x_1)^2+ b (alpha x_2)^2)= sqrt(alpha^2 (a x_1^2 +b x_2^2)) =abs(alpha) norm(x)_(a,b)
  $

  *(iii)* Lấy $x,y in E : x=(x_1,x_2); y=(y_1,y_2)$. Ta chứng minh $ norm(x+y)_(a,b) <= norm(x) +norm(y) $
  Có
  $
    norm(x+y)_(a,b)^2=a(x_1+y_1)^2+b(x_2+y_2)^2= a x_1^2 + b x_2^2 + a y_1^2 +b y_2^2 +2 ( a x_1 y_1 +b x_2 y_2)
  $
  Áp dụng bất đẳng thức Cauchy-Schwarch cho $a x_1 y_1 + b x_2 y_2$, ta được
  $
    a x_1 y_1 + b x_2 y_2 <= sqrt(a x_1^2 +b x_2^2) sqrt(a y_1^2 +b y_2^2)
  $
  Do đó,
  $
    norm(x+y)^2<= (norm(x)+norm(y))^2 => norm(x+y)<=norm(x)+norm(y)
  $
  Vậy, từ (i),(ii),(iii) suy ra $(E,norm(.)_(a,b))$ là  không gian định chuẩn.

  *b)* Ta có thể nhận xét, mọi chuẩn trên không gian hữu hạn chiều đều tương đương nên ta có điều phải chứng minh.

  Mặt khác, ta chứng minh chặt chẽ như sau, tìm $m>0 and M>0$ sao cho
  $
    m norm(.)_(1,8) <= norm(.)_(7,9) <= M norm(.)_(1,8)
  $
  Thật vậy, với $x in E$, có $norm(x)_(1,8)=sqrt(x_1^2+8x_2^2) => "tìm m">0 "sao cho" m sqrt(x_1^2+8 x_2^2) <= sqrt(7 x_1^2 +9x_2^2)=> "chọn m="1/8 >0$.

  Hơn nữa, tìm $M>0$ sao cho $norm(x)_(7,9)<=M norm(x)_(1,8) => "chọn" M=10$.

  Thì ta có điều phải chứng minh.

  *Câu 2*

  *a)* Với $u=0$ và $r=5$, khi đó lấy $x in B_(2,3) (u, r)$. Ta có $ norm(x-u)=norm(x)_(2,3)=sqrt(2 x_1^2 + 3 x_2^2)<5 <=> 2 x_1^2 +3 x_1^2 < 25 $ Hơn nữa, nếu $x in B_(4,6) (u,r)$, thì $ 4x_!^2 + 6x_2^2 <25 $Từ $2$ điều trên, ta có thể nhận xét $ B_(2,3) (u, r) subset.not B_(4,6) (u,r) $Thật vậy, ta có thể chọn $x=(2,2) in B_(2,3) (u,r)$ nhưng $x in.not B_(4,6) (u,r)$.

  Lấy $x in B_(4,6) (u,r)$, khi đó ta có $4x_1^2+6 x_2^2 < 25 => 2 x_1^2 +3 x_2^2 <15/2 <25 => x in B_(2,3) (u, r)$. Do đó, $B_(4,6) (u,r) subset B_(2,3) (u,r)$.

  *b)* Lấy $(x_n)$ là dãy Cauchy bất kỳ thuộc $E$. Ta tìm $x in E$ sao cho $(x_n) -> x$, hay $lim_(n-> infinity) delta(x_n, x)=0$. Đặt $(x_n)=(u_n,v_n)$. Khi đó, vì $x_n$ là dãy Cauchy, nên với mỗi $epsilon>0$, luôn có $N(epsilon) in NN$, sao cho $forall m,n >= N(epsilon)$, thì $delta(x_n, x_m)<epsilon$.Khi đó,
  $
    delta_(a,b)(x_n,x_m)=sqrt(a (u_n-u_m)^2+b(v_n-v_m)^2)<epsilon => cases(abs(u_n - u_m)<epsilon/sqrt(a), abs(v_n-v_m)<epsilon/sqrt(b))
  $
  Mặt khác, $(RR,abs(.))$ là không gian Bannach, mà $(u_n)$ và $(v_n)$ là $2$ dãy Cauchy trong không gian trên, nên ta tìm được $u' in RR$ và $v' in RR$ sao cho $(u_n ) -> u' "và" (v_n) -> v'$. Do đó, nếu đặt $u=u'+v'$, thì ta có
  $
    lim_(n->infinity) delta(x_n, x)=sqrt(a (u_n-u')^2+ b(v_n-v')^2)=0
  $
  Vì $(x_n)$ là dãy Cauchy tùy ý của $E$, nên ta có $E$ là không gian metric đầy đủ.


  *Câu 3*
  Lấy bất kỳ $x in C([a,b])$, khi đó cho trước $epsilon>0$, tìm $delta>0$ sao cho với $y in C([a,b])$ cho trước, nếu $delta_E (x,y)<delta$ thì cần $delta_F (f(x),f(y))<epsilon$.

  Có $ delta_F (f(x),f(y))=integral_a^b abs(x(t)-y(t)+1/2 (x^2(t)-y^2(t))) dif t $
  Với cách tiếp cận như trên, ta phải giải tam thức bậc 2 của $delta$.

  Tiếp cận cách khác.

  Lấy $(x_n) in C([a,b])$ giả sử $x_n -> x in C([a,b])$. Ta chứng minh $f(x_n) -> f(x) in C([a,b])$. Vì $x_n -> x => lim_(n-> infinity) delta_E (x_n,x)=0$ , ta cần $ lim_(n->infinity) delta_F (f(x_n),f)=0 $
  Thật vậy, có
  $
    delta_F (f(x_n),f(x)) & =integral_a^b abs(x_n (t)-x(t)+1/2 (x^2_n (t)-x^2(t))) dif t \
                          & <= integral_a^b abs(x_n (t)-x(t))+1/2integral_a^b abs((x^2_n (t)-x^2(t))) dif t \
                          & <=delta_E (b-a) + 1/2 delta_E (delta_E + 2M)(b-a) "với "M=sup_(t in [a,b]) abs(x(t)). \
                          & =delta_E (b-a)(1/2 delta_E + 2M)
  $

  Mặt khác, ta luôn có
  $
    0<=abs(delta_F (f(x_n),f(x)))<= delta_E (b-a) (1/2 delta_E+2 M
    )
  $
  Khi đó, với $n-> infinity$, thì $delta_E ->0$, nên theo nguyên lý kẹp, ta được
  $
    lim_(n->infinity) delta_F (f(x_n), f(x))=0
  $

  *b)*

  Nếu $alpha=0$, thì hiển nhiên $g+ alpha h$ liên tục đều trên $E$.

  Với $alpha !=0$, thì từ $h$ liên tục đều trên $E$, suy ra $alpha h$ liên tục đều trên $E$.Hơn nữa, với $G$ liên tục đều trên $E$, ta thu được
  $
    g+ alpha h "liên tục đều trên E"
  $


  *Câu 4*

  Lấy $x in [0,2]$ ta kiểm tra
  $
    lim_(n->infinity) f_n (x)=lim_(n -> infinity) abs(x-1)^n = cases(0 quad&:1<=x<=2, 1 &:x=0, 0 &:0<x<=1)
  $
  Vậy, $f_n (x)$ hội tụ điểm về
  $
    f(x)=cases(0 &: 1<=x<=2, 1 &: x=0, 0 &: 0<x<=1)
  $





]
#pagebreak()
== 2025-2026 -- Lê Ánh Hạ

#cau[
  Cho $X = C([0,1])$ là tập hợp những hàm số liên tục trên $[0,1]$. Xét hàm số
  $
    d: X times X -> RR
  $
  $
    (x,y) mapsto d(x,y) = integral_0^1 (2t+1) abs(x(t)-y(t)) "d"t
  $

  Chứng minh rằng $d$ là một metric trên $X$.
]

#cau[
  Trên $RR^2$, cho hàm số
  $
    d: RR^2 times RR^2 -> RR
  $
  $
    (x,y) mapsto d(x,y) = sqrt(2(y_1-x_1)^2 + 3(y_2-x_2)^2)
  $
  với $x=(x_1,x_2)$, $y=(y_1,y_2) in RR^2$.

  a) Chứng minh rằng $d$ là một metric đầy đủ trên $RR^2$.

  b) Cho $D = {(x_1,x_2) in RR^2 : x_1^2+x_2^2 < 3}$, chứng minh $D$ là tập mở trong $(RR^2,d)$. Tìm bao đóng của $D$.

  c) Tập $A = {(x_1,x_2) in RR^2 : x_1 >= 0, x_1^2+x_2^4 <= 3}$ có là tập compact trên metric $(RR^2,d)$ hay không? Vì sao?

  d) Tập $B = {(x_1,x_2) in RR^2 : x_1 >= 0, x_1^2+x_2^3 <= 3}$ có là tập compact trên metric $(RR^2,d)$ hay không? Vì sao?
]
#loigiai[

  *Câu 1*

  Ta chứng minh $d$ là một metric trên $X$.

  *i)* Với $x,y in X$ có $ d(x,y)=integral_0^1(2 t+1) abs(x(t)-y(t)) dif t=integral_0^1 (2 t+1 ) abs(y(t)-x(t)) dif t $.

  *ii)* Với $x,y in X$, giả sử $d(x,y)=0$, khi đó
  $
    integral_0^1 (2t+1) abs(x(t)-y(t)) dif t & =0 \
                                             & <=> x(t)=y(t) , forall t in [0,1] \
                                             & <=> x=y.
  $

  *iii)* Lấy $x,y,z in X$, ta chứng minh

  $
    d(x,y)<=d(x,z)+d(z,y)
  $
  Mặt khác, vì $(R,d_(t t))$ là không gian metric đầy đủ, nên với mỗi $t in [0,1]$, ta luôn có
  $
    abs(x(t)-y(t))<=abs(x(t)-z(t))+abs(z(t)-y(t)) quad (1)
  $
  Với mỗi $t in [0,1]$ thì $(2 t+1 )>0$, do đó nhân $2$ vế của $(1)$ cho $(2 t+1)$ , ta được
  $
    (2 t+1) abs(x(t)-y(t)) <= (2 t+1)abs(x(t)-z(t))+ (2 t+1) abs(z(t)-y(t))
  $
  Do đó, lấy tích phân từ $0 -> 1$, ta được
  $
    integral_0^1 (2 t+1) abs(x(t)-y(t)) dif t &<=integral_0^1 (2 t+1) abs(x(t)-z(t)) dif t + integral_0^1 (2 t+1)abs(z(t)-y(t))dif t \
    &=d(x,z) + d(z,y)
  $
  Vậy, $d$ là một metric.

  *Câu 2*

  Ta có nhận xét sau, với không gian $X$ và có metric $d_A$ và $d_B$, hơn nữa $d_A$ và $d_B$ tương đương, nghĩa là có $m,m>0$ sao cho
  $
    m d_A(x,y) <= d_B(x,y)<=M d_A (x,y)
    forall x,y in X
  $
  Khi đó, nếu $(X,d_A)$ đầy đủ thì $(X,d_B)$ cũng đầy đủ.

  Chứng minh, nhận xét trên. Lấy một dãy Cauchy bất kỳ $(x_n)$ trong $(X,d_B)$, do ,
  $
    d_A(x_m,x_n)<=1/m d_B(x_m,x_n).
  $
  Nên $(x_n)$ cũng là dãy Cauchy trong $(X,d_A)$. Vì $(X,d_A)$ đầy đủ nên $(x_n)$ hội tụ, dẫn đên có $x in X$ sao cho $ lim_(n->infinity) d_A(x_n,x)=0 $
  Mặt khác,
  $
    0<=d_B(x_n,x)<=M d_A(x_n,x) -> 0
  $
  Vậy, $x_n -> x$ theo metric $d_B$. Do đó, $(X,d_B)$ đầy đủ.


  Khi đó, với $X=RR^2$, và $ d(x,y)=sqrt(2(x_1-y_1)^2+3(x_2-y_2)^2) $
  Xét $d_2 (x,y)$ là metric Euclid thông thường trên $RR^2$, khi đó ta chứng minh $d$ và $d_2$ tương đương.

  Giả sử có $M>0$ sao cho
  $
    d (x,y)<=M d_2(x,y) <=> 2(x_1-y_1)^2 +3(x_2-y_2)^2 <= M^2[(x_1-y_1)^2+(x_2-y_2)^2] => "chọn "M^2=100=>M=10
  $
  Tương tự, giả sử có $m>0$ sao cho
  $
    m d_2(x,y) <= d(x,y) <=> m^2[(x_1-y_1)^2+(x_2-y_2)^2]<=2 (x_1-y_1)^2 + 3(x_2-y_2)^2 => "chọn "m=1/sqrt(5)
  $
  Do đó, ta có $d$ và $d_2$ tương đương, mặt khác $(RR^2,d_2)$ đầy đủ, nên suy ra $(RR^2,d)$ đầy đủ.

  *b)*

  Ta chứng minh $D$ là tập mở trong $(RR^2,d)$ bằng $2$ cách.

  *Cách 1* Lấy $x=(x_1,x_2) in D$, tìm $r_x>0$ sao cho $B(x,r) subset D$.

  Cho trước $y=(y_1,y_2) in B(x,r)$, ta chứng minh $y_1^2+y_2^2 <3$.

  Với $x in D$, ta luôn có $x_1^2+x_2^2 <3$

  Xuất phát từ điều cần chứng minh với $y_1^2+y_2^2<3$.

  Ta cố gắng đưa $x_1,x_2$ vào điều cần chứng minh. Khi đó, $y_1=$




]
#pagebreak()
== 2025-2026 -- Trần Thị Khiếu
#cau[
  (2 điểm) Trong $RR^2$, cho:
  $
    d(x,y) = abs(x_1-y_1) + abs(x_2-y_2)
  $
  với $x=(x_1,x_2)$, $y=(y_1,y_2) in RR^2$.

  a) Chứng minh rằng $(RR^2,d)$ là không gian metric đầy đủ.

  b) Cho $D = {(x,y) in RR^2 : x^2+y^2 <= 2x}$. Chứng minh $D$ là tập compact trong $(RR^2,d)$.
]

#cau[
  (1.5 điểm) Cho $E=C([0,1])$ là không gian các hàm số liên tục trên $[0,1]$. Xét một metric sau:
  $
    d(f,g) = integral_0^1 abs(f(t)-g(t)) dif t
  $

  Hỏi dãy $f_n(t)=t^n$ ($n in NN$) có là một dãy Cauchy trong $(E,d)$ hay không? Nếu ${f_n}$ hội tụ trong $(E,d)$ thì có đủ khẳng định rằng $(E,d)$ là không gian metric đầy đủ hay không?
]

#cau[
  (2 điểm) Cho $E=C([0,1])$ với mọi $x,y in E$ ta định nghĩa:
  $
    delta(x, y) = sup_(0 <= t <= 1) abs(x(t)-y(t))
  $

  Đặt, với mỗi $n in NN$,
  $
    A(x) = 1/n integral_(1/(n+1))^(1/n) x^2(t) dif t.
  $

  Chứng minh rằng $A$ là ánh xạ liên tục đều từ $E$ vào $RR$.
]

#cau[
  (3 điểm) Cho dãy hàm ${f_n}$ thỏa:
  $
    f_n(x) = n x e^(-n x), quad x >= 0
  $

  a) Chứng minh rằng ${f_n}$ hội tụ đều trên $[1,+oo)$.

  b) Chứng minh rằng ${f_n}$ không hội tụ đều trên $[0,1]$.
]

#cau[
  (1.5 điểm) Chứng minh:

  a) Xét hai không gian metric $(E,delta_E)$ và $(F,delta_F)$. Cho ánh xạ $f:E -> F$ liên tục trên $E$. Chứng minh rằng $U$ mở trong $F$ thì $f^(-1)(U)$ mở trong $E$.

  b) Cho $f$ là ánh xạ liên tục giữa hai không gian metric $X=(RR,d_1)$, $Y=(RR,d_2)$ với $d_1(x,y)=d_2(x,y)=abs(x-y)$, $forall x,y in RR$. Chứng minh rằng nếu $A$ là tập đóng và bị chặn trong $X$ thì $f(A)$ đóng và bị chặn trong $Y$.
]

