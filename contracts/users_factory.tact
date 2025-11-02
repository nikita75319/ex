import "./messages";
import "./user";
import "@stdlib/deploy";

contract UsersFactory {
    owner: Address;
    quantityOfUsers: Int as uint256;

    init(owner: Address) {
        self.owner = owner;
        self.quantityOfUsers = 1;
    }

    receive(msg: MakeNewUser) {
        let init: StateInit = initOf User(myAddress());

        send(SendParameters {
            bounce: false,
            to: contractAddress(init),
            value: ton("0.2"),
            mode: SendIgnoreErrors,
            code: init.code,
            data: init.data,
        });
        self.quantityOfUsers += 1;
    }

    receive() {
        cashback(sender());
    }

    get fun cntUsers(): Int {
        return self.quantityOfUsers;
    }

    get fun userAddress(parent: Address): Address {
        return contractAddress(initOf User(parent));
    }
}
