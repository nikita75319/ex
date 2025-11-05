import "@stdlib/ownable";
import "./messages";
import "./user";
import "./order";

// Since v1.6.0, Tact has a contract parameters syntax that can supersede
// lazy initialization by init() for all contracts that do not require specific on-chain
// deployment logic that must be run only once in the `init()` function.
//
// Note that the empty parameter list above is still a parameter list,
// meaning that the contract won't have an implicit or explicit `init(){:tact}` function
// and will enjoy storage write optimizations and use less gas overall.
//
// See: https://docs.tact-lang.org/book/contracts/#parameters
contract Item{
    // Empty receiver for the deployment,
    // which expects the `null` message body
    shop: Address;
    id: Int as uint256;
    price: Int as coins;
    imageSrc: String;
    title: String;
    description: String;

    init(shop: Address, id: Int as uint256, price: Int as coins, imageSrc: String, title: String, description: String) {
        self.shop = shop;
        self.id = id;
        self.price = price;
        self.imageSrc = imageSrc;
        self.title = title;
        self.description = description;
    }

    receive(msg: CreateOrder) {
        let init: StateInit = initOf Order(self.shop, sender(), myAddress(), msg.orderId, msg.deliveryAddress);

        send(SendParameters {
            to: contractAddress(init),
            value: msg.price,
            mode: SendIgnoreErrors,
            code: init.code,
            data: init.data,
        });

        send(SendParameters {
            to: self.shop,
            value: msg.price,
            body: NewOrder {
                deliveryAddress: msg.deliveryAddress,
                itemIndex: self.id,
                price: self.price,
            }.toCell(),
            mode: SendIgnoreErrors,
        });
        self.reply("Order created".asComment());
    }

    get fun shop(): Address { return self.shop; }
    get fun id(): Int { return self.id; }
    get fun price(): Int { return self.price; }
    get fun imageSrc(): String { return self.imageSrc; }
    get fun title(): String { return self.title; }
    get fun description(): String { return self.description; }
}
