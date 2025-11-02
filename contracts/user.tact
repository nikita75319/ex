import "./messages";
import "@stdlib/deploy";

contract User with Deployable {
    parent: Address;
    id: Int as uint256;
    name: String;
    deliveryAddress: String;

    init(parent: Address) {
        self.parent = parent;
        self.id = 1;
        self.name = "";
        self.deliveryAddress = "";
    }

    receive(msg: ChangeUserData) {
        require(sender() == self.parent, "Only parent can change user data");
        self.name = msg.name;
        self.id = msg.id;
        self.deliveryAddress = msg.deliveryAddress;
    }

    receive(msg: MakeOrder) {
        send(SendParameters {
            to: msg.itemAddress,
            value: msg.price,
            body: CreateOrder {
                itemAddress: msg.itemAddress,
                deliveryAddress: self.deliveryAddress,
                price: msg.price,
            }.toCell(),
            mode: SendIgnoreErrors
        });
        
    }
}
