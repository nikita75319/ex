import "./messages";
import "./user";
import "@stdlib/deploy";

contract UsersFactory with Deployable {
    owner: Address;
    quantityOfUsers: Int as uint256;

    init(owner: Address) {
        self.owner = owner;
        self.quantityOfUsers = 1;
    }

    receive(msg: MakeNewUser) {
        let init: StateInit = initOf User(myAddress(), self.quantityOfUsers);

        send(SendParameters {
            bounce: false,
            to: contractAddress(init),
            value: ton("0.2"),
            body: ChangeUserData {
                name: msg.name,
                deliveryAddress: msg.deliveryAddress,
            }.toCell(),
            mode: SendIgnoreErrors,
            code: init.code,
            data: init.data,
        });
        self.quantityOfUsers += 1;
    }

    get fun cntUsers(): Int {
        return self.quantityOfUsers;
    }

    get fun userAddress(id: Int): Address {
        return contractAddress(initOf User(myAddress(), id));
    }
}
