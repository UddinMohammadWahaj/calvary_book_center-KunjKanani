class EcommerceModel {
  final String title;
  final String? image, svgSrc;
  final List<EcommerceModel>? subCategories;

  EcommerceModel({
    required this.title,
    this.image,
    this.svgSrc,
    this.subCategories,
  });
}

final List<EcommerceModel> demoEcommercesCategories = [
  EcommerceModel(
    title: "New Arrivals",
    svgSrc: "assets/newIcon/new.png",
    subCategories: [
      EcommerceModel(title: "New Bible books"),
    ],
  ),
  EcommerceModel(
    title: "Dairies",
    svgSrc: "assets/newIcon/diary.png",
    subCategories: [
      EcommerceModel(title: "Calenders"),
      EcommerceModel(title: "New Diaries"),
      EcommerceModel(title: "Notebooks"),
    ],
  ),
  EcommerceModel(
    title: "Bibles",
    svgSrc: "assets/newIcon/bible.png",
    subCategories: [
      EcommerceModel(title: "Telugu Bibles"),
      EcommerceModel(title: "Referebce Bibles"),
      EcommerceModel(title: "English Bibles"),
      EcommerceModel(title: "Study Bibles"),
    ],
  ),
  EcommerceModel(
    title: "Kids",
    svgSrc: "assets/icons/Man&Woman.svg",
    subCategories: [
      EcommerceModel(title: "Kid's Special"),
      EcommerceModel(title: "Kids Bags"),
      EcommerceModel(title: "Kannada bible"),
      EcommerceModel(title: "Wrist Bands"),
    ],
  ),
  EcommerceModel(
    title: "Special Offers",
    svgSrc: "assets/newIcon/special.png",
    subCategories: [
      EcommerceModel(title: "Calvary Books"),
      EcommerceModel(title: "Wrist Band"),
      EcommerceModel(title: "Digital Song Books"),
      EcommerceModel(title: "Book"),
    ],
  ),
  EcommerceModel(
    title: "Prayer",
    svgSrc: "assets/newIcon/prayring.png",
    subCategories: [
      EcommerceModel(title: "Prayer Oil"),
      EcommerceModel(title: "Wrist Band"),
    ],
  ),
  EcommerceModel(
    title: "New Book",
    svgSrc: "assets/newIcon/book.png",
    subCategories: [
      EcommerceModel(title: "Family Devotional Books"),
    ],
  ),
  EcommerceModel(
    title: "Articles",
    svgSrc: "assets/newIcon/article.png",
    subCategories: [
      EcommerceModel(title: "Stricker"),
      EcommerceModel(title: "Car Stands"),
      EcommerceModel(title: "Car Hangers"),
      EcommerceModel(title: "Saving Money Box"),
    ],
  ),
  EcommerceModel(
    title: "Clocks",
    svgSrc: "assets/newIcon/clock.png",
    subCategories: [
      EcommerceModel(title: "Wall Clocks"),
    ],
  ),
  EcommerceModel(
    title: "Books",
    svgSrc: "assets/newIcon/book.png",
    subCategories: [
      EcommerceModel(title: "Calvary Books"),
      EcommerceModel(title: "Song Books"),
      EcommerceModel(title: "Prayer Books"),
      EcommerceModel(title: "Calvary Family Books"),
      EcommerceModel(title: "Youth Books"),
    ],
  ),
  EcommerceModel(
    title: "Key Chains",
    svgSrc: "assets/newIcon/keychain.png",
    subCategories: [
      EcommerceModel(title: "Normal Key Chain"),
      EcommerceModel(title: "Wood Key Chains"),
    ],
  ),
  EcommerceModel(
    title: "MC & Pen",
    svgSrc: "assets/newIcon/pen.png",
    subCategories: [
      EcommerceModel(title: "40 Days Prayer"),
      EcommerceModel(title: "Calvary 16 Albums Songs"),
    ],
  ),
  EcommerceModel(
    title: "Bible Covers",
    svgSrc: "assets/newIcon/clean_book.png",
    subCategories: [
      EcommerceModel(title: "Normal Bible Cover"),
      EcommerceModel(title: "Maty Bible Cover"),
    ],
  ),
  EcommerceModel(
    title: "Wallets",
    svgSrc: "assets/newIcon/wallet.png",
    subCategories: [
      EcommerceModel(title: "Ladies Wallets"),
      EcommerceModel(title: "Gents Wallets"),
    ],
  ),
  EcommerceModel(
    title: "LED",
    svgSrc: "assets/newIcon/led.png",
    subCategories: [
      EcommerceModel(title: "LED Lights"),
    ],
  ),
  EcommerceModel(
    title: "Musical",
    svgSrc: "assets/newIcon/musical.png",
    subCategories: [
      EcommerceModel(title: "Kanjira"),
      EcommerceModel(title: "Dappu"),
    ],
  ),
  EcommerceModel(
    title: "Frames",
    svgSrc: "assets/newIcon/frame.png",
    subCategories: [
      EcommerceModel(title: "Without Glass Frames"),
      EcommerceModel(title: "With Glass Frames"),
    ],
  ),
  EcommerceModel(
    title: "Kananada Special",
    svgSrc: "assets/newIcon/special.png",
    subCategories: [
      EcommerceModel(title: "Kananada Messages"),
      EcommerceModel(title: "Memory Cards"),
    ],
  ),
  EcommerceModel(
    title: "Bags",
    svgSrc: "assets/newIcon/bag.png",
    subCategories: [
      EcommerceModel(title: "Leather Bag"),
      EcommerceModel(title: "Laptop Bags"),
      EcommerceModel(title: "Mike Bags"),
      EcommerceModel(title: "Bible Bags"),
    ],
  ),
  EcommerceModel(
    title: "Pens",
    svgSrc: "assets/newIcon/pen.png",
    subCategories: [
      EcommerceModel(title: "Nomral Pens"),
      EcommerceModel(title: "Metal Pens"),
    ],
  ),
  EcommerceModel(
    title: "Communion Items",
    svgSrc: "assets/newIcon/communion.png",
    subCategories: [
      EcommerceModel(title: "Normal Communion Items"),
      EcommerceModel(title: "Steel Communion Items"),
      EcommerceModel(title: "Wooden Communion Items"),
      EcommerceModel(title: "Communion Bread"),
    ],
  ),
  EcommerceModel(
    title: "Cristmas Items",
    svgSrc: "assets/newIcon/cristmas.png",
    subCategories: [
      EcommerceModel(title: "Cristmas and Bible"),
    ],
  ),
];
