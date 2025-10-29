import "@stdlib/ownable";
import "./messages";
import "./user";

// Since v1.6.0, Tact has a contract parameters syntax that can supersede
// lazy initialization by init() for all contracts that do not require specific on-chain
// deployment logic that must be run only once in the `init()` function.
//
// Note that the empty parameter list above is still a parameter list,
// meaning that the contract won't have an implicit or explicit `init(){:tact}` function
// and will enjoy storage write optimizations and use less gas overall.
//
// See: https://docs.tact-lang.org/book/contracts/#parameters
contract UniqueItem with Ownable {
    // Empty receiver for the deployment,
    // which expects the `null` message body
    shop: Address;
    owner: Address;
    content: String; // prev itemName
    index: Int as uint256;
    price: Int as coins;

    init(shop: Address, owner: Address, content: String, index: Int, price: Int as coins) {
        self.shop = shop;
        self.owner = owner;
        self.content = content;
        self.index = index;
        self.price = price;
    }

    receive(msg: NftTransfer) {
        self.requireOwner();
        self.owner = msg.newOwner;
        self.reply("Item transfered".asComment());
    }

    receive(msg: CreateOrder) {
        // логика замророзки средств
        send(SendParameters {
            to: self.shop,
            value: msg.price,
            body: NewOrder {
                deliveryAddress: msg.deliveryAddress,
                itemIndex: self.index,
                price: self.price,
            }.toCell(),
            mode: SendIgnoreErrors,
        });
        self.reply("Order created".asComment());
    }

    get fun index(): Int {
        return self.index;
    }
}
