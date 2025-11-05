import "./messages";
import "./unique_item";

contract Order {
    seller: Address;
    buyer: Address;
    itemAddress: Address;
    id: Int as uint256;
    completed: Bool = false;
    deliveryAddress: String;

    init(seller: Address, buyer: Address, itemAddress: Address, id: Int as uint256, deliveryAddress: String) {
        self.seller = seller;
        self.buyer = buyer;
        self.itemAddress = itemAddress;
        self.id = id;
        self.deliveryAddress = deliveryAddress;
    }

    receive() {
        cashback(sender());
    }

    receive(msg: OrderCompleted) { self.completed = true; }
    get fun seller(): Address { return self.seller; }
    get fun buyer(): Address { return self.buyer; }
    get fun itemAddress(): Address { return self.itemAddress; }
    get fun id(): Int { return self.id; }
    get fun completed(): Bool { return self.completed; }
}
