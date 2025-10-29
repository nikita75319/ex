import "@stdlib/ownable";
import "./messages";
import "./shop";

contract ShopFactory with Ownable {
    // state
    owner: Address;
    // shops: Map<Int, Address>   // id -> shop address
    shopsCount: Int as uint256;

    // constructor
    init(owner: Address) {
        self.owner = owner;
        self.shopsCount = 0;
    }

    receive() {}

    receive(msg: CreateShop) {
        let init: StateInit = initOf Shop(myAddress(), sender(), msg.shopName, self.shopsCount);

        send(SendParameters {
            to: contractAddress(init),
            value: ton("0.02"),
            mode: SendIgnoreErrors,
            code: init.code,
            data: init.data,
        });

        let reply: StringBuilder = beginString();
        reply.append("Shop #");
        reply.append(self.shopsCount.toString());
        reply.append(" created");
        self.reply(reply.toString().asComment());

        self.shopsCount += 1;
    }

    get fun shopAddress(index: Int, owner: Address, shopName: String): Address {
        let init: StateInit = initOf Shop(myAddress(), owner, shopName, index);
        return contractAddress(init);
    }

    get fun shopCount(): Int {
        return self.shopsCount;
    }

    // create a shop for caller(or specify owner)
    //   public func create_shop(owner_addr: Address) -> Address {
    //     // deploy new Shop contract with owner = owner_addr
    //     let shop_addr = deploy Shop(owner_addr, factory_address = SELF);
    //     shopCount += 1;
    //     shops[shopCount] = shop_addr;
    //     // emit event OrderCreated(shop_addr, owner_addr)
    //     return shop_addr;
    //   }

    // optionally: fee for shop creation
    // public func set_creation_fee(fee: Coins) { require(msg.sender == owner); creation_fee = fee; }
}
