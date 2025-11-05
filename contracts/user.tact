import "./messages";
import "@stdlib/deploy";

contract User with Deployable {
    owner: Address;
    id: Int as uint256;
    name: String;
    deliveryAddress: String;

    init(owner: Address) {
        self.owner = owner;
        self.id = 1;
        self.name = "";
        self.deliveryAddress = "";
    }

    receive(msg: ChangeUserData) {
        self.name = msg.name;
        self.id = msg.id;
        self.deliveryAddress = msg.deliveryAddress;
    }
}
