message(0xdc6a8b83) MakeNewUser {
    name: String;
    id: Int;
}

message(0x7f22ed74) ChangeUserData {
    name: String;
    id: Int;
    deliveryAddress: String;
}

message(0xc6366b42) CreateShop {
    shopName: String;
}

message(0xfe3511b0) AddItem {
    isUnique: Bool;
    content: String;
    price: Int as coins;
}

message(0xd9f8bfac) NftTransfer {
    newOwner: Address;
    isSalable: Bool;
}

message(0x591763ee) NftTransferNotification {
    itemIndex: Int;
    oldOwner: Address;
    newOwner: Address;
}

message(0x7ac14988) CreateOrder {
    itemAddress: Address;
    deliveryAddress: String;
    price: Int as coins;
}

// message SetNewPrice {
//     newPrice: Int as coins;
// }

// message SetSalable {
//     isSalable: Bool;
// }

message(0x9b6fea82) SetPrice {
    newPrice: Int as coins;
    isSalable: Bool;
}

message(0xc46fecd7) SetUniqueItemPrice {
    uniqueItem: Address;
    newPrice: Int as coins;
}

message(0xfdc52c75) GetPrice {}

message(0x7c95a1fc) GetPriceResponse {
    price: Int as coins;
}

// message OrderPayment {
//     orderIndex: Int;
//     itemAddress: Address;
//     buyer: Address;
// }

message(0xe6e77cc0) NftTransferSuccess {}

message(0x993e1ed5) OrderCompleted {
    orderIndex: Int;
    itemAddress: Address;
    buyer: Address;
}

message(0x75bc02e6) MakeOrder {
    itemAddress: Address;
    price: Int as coins;
}

message(0x90268e31) NewOrder {
    deliveryAddress: String;
    itemIndex: Int as uint256;
    price: Int as coins;
}

message UpdateShopInfo {
    shopName: String;
    shopId: Int as uint256;
    uniqueItemsCount: Int as uint256;
    ordersCount: Int as uint256;
}
