message MakeNewUser {
    name: String;
    deliveryAddress: String;
}

message ChangeUserData {
    name: String;
    deliveryAddress: String;
}

message CreateShop {
    shopName: String;
}

message AddItem {
    isUnique: Bool;
    content: String;
    price: Int as coins;
}

message NftTransfer {
    newOwner: Address;
    isSalable: Bool;
}

message NftTransferNotification {
    itemIndex: Int;
    oldOwner: Address;
    newOwner: Address;
}

message CreateOrder {
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

message SetPrice {
    newPrice: Int as coins;
    isSalable: Bool;
}

message SetUniqueItemPrice {
    uniqueItem: Address;
    newPrice: Int as coins;
}

message GetPrice {}

message GetPriceResponse {
    price: Int as coins;
}

// message OrderPayment {
//     orderIndex: Int;
//     itemAddress: Address;
//     buyer: Address;
// }

message NftTransferSuccess {}

message OrderCompleted {
    orderIndex: Int;
    itemAddress: Address;
    buyer: Address;
}

message MakeOrder {
    itemAddress: Address;
    price: Int as coins;
}

message NewOrder {
    deliveryAddress: String;
    itemIndex: Int as uint256;
    price: Int as coins;
}
