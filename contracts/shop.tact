import "@stdlib/ownable";
import "./messages";
import "./item";
import "./order";

contract Shop with Ownable {
    owner: Address;
    name: String;
    itemsCount: Int as uint256;
    shopId: Int as uint256;
    ordersCount: Int as uint256;
    balance: Int as coins = 0;

    init(owner: Address) {
        self.owner = owner;
        self.name = "shopName";
        self.shopId = 1;
        self.itemsCount = 0;
        self.ordersCount = 0;
    }

    receive(msg: UpdateShopInfo) {
        self.name = msg.shopName;
        self.shopId = msg.shopId;
    }

    receive(msg: AddItem) {
        self.requireOwner();
        let init: StateInit = initOf Item(myAddress(), self.itemsCount, msg.price, msg.imageSrc, msg.title, msg.description);

        send(SendParameters {
            to: contractAddress(init),
            value: msg.price,
            mode: SendIgnoreErrors,
            code: init.code,
            data: init.data,
        });

        self.itemsCount += 1;
    }

    receive(msg: NewOrder) {
        self.balance += msg.price;
        // передача и обработка данных пользователя и товара
        self.ordersCount += 1;
    }

    get fun shopName(): String {
        return self.name;
    }
}
