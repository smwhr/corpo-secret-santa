=== init_en
Your mission, should you choose to accept it, is to investigate who offered what to whom during the Acme Inc. Secret Santa.

+ [And when I'm done?]
-

When you feel you know enough, just leave the office. You'll be asked four questions. You have to answer them all correctly to prove you got it right.

-(opts)
* [Any final advice?]
    You should have a pen and paper handy. Or an Excel spreadsheet. Whatever helps you figure it out.
    ->opts
+ [Let's investigate!]
-

-> loop_en

=== loop_en
+ [tag: alice Alice] 
    ALICE: I'm Alice.
    ALICE: David and I we are lucky enough to have out own office.
    ALICE: I received a seasonal gift!
    ALICE: I'm not well accointed with the people seated in the open-space so I brought back something from my last trip abroad.
+ [tag: benjamin Benjamin] 
    BENJAMIN: Hi, I'm Benjamin!
    BENJAMIN: I know what the colleague seated to my left bought as a present, I saw here ordering it online.
    BENJAMIN: Everytime someone goes abroad, they send a postcard.
+ [tag: caroline Caroline] 
    CAROLINE: Hi, I'm Caroline!
    CAROLINE: I bought a seasonal gift in a boutique shop downtown.
    CAROLINE: The gift I received is so cute! When I have consumed it all I'll put it on my desk as decoration. In fact, it's already there.
    CAROLINE: I made sure that you could not receive a gift from the person you're offering to.
+ [tag: david David] 
    DAVID: I'm David.
    DAVID: I didn't really know where to put my gift since its recipient has no desk in the office.
    DAVID: I found my gift on my own desk. It's still there.
    DAVID: I received a seasonal gift!
+ [tag: emily Emily] 
    EMILY: Hi, I'm Emily!
    EMILY: I never offer anything edible, you never know whether people have dietary restriction.
    EMILY: It was very embarassing having to find a gift when the person it goes to is in the same room all day!
+ [tag: francis Francis] 
    FRANCIS: Hi, I'm Francis!
    FRANCIS: I bought my present this summer while on vacation. It's a local specialty!
    FRANCIS: I know Emily very well and it was obvious the gift she received clashed with her personal beliefs.
+ [tag: geraldine Geraldine] 
    GERALDINE: Hi, I'm Geraldine!
    GERALDINE: I like to offer do-it-yourself presents.
    GERALDINE: The recipient of my gift is seated in front of me all day.
    GERALDINE: I lent the gift I received to someone who put it on their desk.
+ [tag: hector Hector] 
    HECTOR: Hi, I'm Hector!
    HECTOR: This cookie preparation is not mine, I'm just looking after it. Though I'd rather have received something edible indeed.
    HECTOR: I offered a seasonal gift!
+ [tag: isabella Isabella] 
    ISABELLA: Hi, I'm Isabella!
    ISABELLA: I always offer edibles! I myself have a sweet tooth and always keeps candies in my desk drawer!
    ISABELLA: If they'd asked me, I'd say the sporty gift would rather be given to Francis!
 

+ [tag: tea Tea]
    It is a well-decorated box of fine English Tea
+ [tag: book Mystery Book]
    It is a book full of riddles and enigmas.
+ [tag: socks Socks]
    These are socks. The left one bears a Santa while the right one has a reindeer on it.
+ [tag: dumbbells Dumbbells]
    Those are heavy dumbbells. 5kg says the label.
+ [tag: lego Lego set]
    This is a lego set to build an ice cream truck.
+ [tag: risotto Risotto]
    This is a pack of risotto. It contains a mix you can just pour in a pan.
+ [tag: cookieprep Cookie Prep]
    This is a jar with all the ingredient to make cookies (except the eggs). A recipe book is attached to it with instruction to succeed.
+ [tag: chocolate Box of chocolate]
    This is a box of chocolates shaped like a XMas Tree.
+ [tag: cottoncandy Bucket of Cotton Candy]
    This is a bucket full of pink fluffy cotton candy.
 
+ [tag: fridge Fridge]
    On the fridge, there are two postcards. One from the UK with a long message signed "E". Another from Italy, terse, unsigned.
 
+ [tag: leave Leave the office]
    -> questionnaire_en
    
-
-> loop_en


=== questionnaire_en
~temp score = 0
First question: What did Francis receive?
    + [A box of tea]
    + [A bucket of cotton candy]
    + [A lego set]
        ~score+=1
    + [A 5kg dumbbel]
-
Second question: Who gifted the Cookie Prep?
    + [Francis]
    + [Isabella]
    + [Benjamin]
    + [Geraldine]
        ~score+=1
-
Third question: Who received the risotto?
    + [Hector]
    + [David]
    + [Benjamin]
        ~score+=1
    + [Caroline]
-
Final question: What did Isabella gift?
    + [A bucket of cotton candy]
        ~score+=1
    + [A mystery book]
    + [A box of XMas Chocolate]
    + [A lego box]
-
{score==4: -> win_en}
Sorry, you only got {score} out of 4 answers right.
Try again to leave when you know more!

-> loop_en
=== win_en

Congratulations, you figured it out!

+ [Show credits]
All characters and gifts hand-drawn by me.
Also the story/puzzle.
3D assets by Keney (Furniture Kit)
Thanks to Robinson and Barnabé for intensive QA.
And happy holidays!
-

->END