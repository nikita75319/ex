import "./messages";
import "@stdlib/deploy";

contract User with Deployable {
    parent: Address;
    id: Int as uint256;
    name: String;
    deliveryAddress: String;

    init(parent: Address, id: Int) {
        self.parent = parent;
        self.id = id;
        self.name = "";
        self.deliveryAddress = "";
    }

    receive(msg: ChangeUserData) {
        require(sender() == self.parent, "Only parent can change user data");
        self.name = msg.name;
        self.deliveryAddress = msg.deliveryAddress;
    }
}
