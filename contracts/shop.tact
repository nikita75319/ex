import "@stdlib/ownable";
import "./messages";
import "./unique_item";
import "./order";

contract Shop with Ownable {
    parent: Address;
    owner: Address;
    shopName: String;
    uniqueItemsCount: Int as uint256;
    shopId: Int as uint256;
    ordersCount: Int as uint256;
    balance: Int as coins = 0;

    init(parent: Address, owner: Address, shopName: String, shopId: Int) {
        self.parent = parent;
        self.owner = owner;
        self.shopName = shopName;
        self.shopId = shopId;
        self.uniqueItemsCount = 0;
        self.ordersCount = 0;
    }

    receive(msg: AddItem) {
        self.requireOwner();

        if (msg.isUnique) {
            let init: StateInit = self.uniqueItemInit(myAddress(), self.uniqueItemsCount);
            send(SendParameters {
                to: contractAddress(init),
                value: ton("0.02"),
                code: init.code,
                data: init.data,
                body: SetPrice { newPrice: msg.price, isSalable: true }.toCell(),
            });
        }

        // } else {
        //     let init:
        // }

        self.uniqueItemsCount += 1;
    }

    receive(msg: SetUniqueItemPrice) {
        self.requireOwner();
        send(SendParameters {
            to: msg.uniqueItem,
            value: ton("0.02"),
            mode: SendIgnoreErrors,
            body: SetPrice { newPrice: msg.newPrice, isSalable: true }.toCell(),
        });

        self.reply("Price setted".asComment());
    }

    receive (msg: CreateOrder) {
        let init: StateInit = initOf Order(self.ordersCount, myAddress(), sender(), msg.itemAddress);

        send(SendParameters {
            to: contractAddress(init),
            value: ton("0.2"),
            code: init.code,
            data: init.data,
            body: "onDeploy".asComment(),
        });

        send(SendParameters {
            to: msg.itemAddress,
            value: ton("0.2"),
            body: NftTransfer { newOwner: contractAddress(init), isSalable: true }.toCell(),
        });

        self.ordersCount += 1;
    }

    // receive(msg: OrderPayment) {
    //     let init: StateInit = initOf Order(msg.orderIndex, myAddress(), msg.buyer, msg.itemAddress);
    //     require(sender() == contractAddress(init));

    //     send(SendParameters {
    //         to: msg.itemAddress,
    //         value: ton("0.02"),
    //         body: NftTransfer {newOwner: msg.buyer}.toCell(),
    //         mode: SendIgnoreErrors
    //     });
    // }

    receive(msg: OrderCompleted) {
        let init: StateInit = self.orderInit(msg.orderIndex, msg.buyer, msg.itemAddress);
        require(contractAddress(init) == sender(), "Invalid data");
    }

    receive(msg: NewOrder) {
        self.balance += msg.price;
        // передача и обработка данных пользователя и товара
    }

    get fun shopName(): String {
        return self.shopName;
    }

    get fun uniqueItemInit(owner: Address, index: Int): StateInit {
        let individual_content: StringBuilder = beginString();
        individual_content.append("https://some-json-file.com/id");
        individual_content.append(index.toString());

        return initOf UniqueItem(owner, myAddress(), index, individual_content.toString());
    }

    get fun orderInit(orderId: Int, buyer: Address, itemAddress: Address): StateInit {
        return initOf Order(orderId, myAddress(), myAddress(), itemAddress);
    }
}
