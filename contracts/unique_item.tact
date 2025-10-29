import "@stdlib/ownable";
import "./messages";

contract UniqueItem with Ownable {
    shop: Address;
    owner: Address;
    content: String; // prev itemName
    index: Int as uint256;
    price: Int as coins = 0;
    isSalable: Bool = false;

    init(owner: Address, shop: Address, index: Int, content: String) {
        self.shop = shop;
        self.owner = owner;
        self.content = content;
        self.index = index;
    }

    receive(msg: GetPrice) {
        require(self.isSalable, "Item not salable yet");
        send(SendParameters {
            to: sender(),
            value: 0,
            mode: SendRemainingValue,
            body: GetPriceResponse { price: self.price }.toCell(),
        });
    }

    receive(msg: SetPrice) {
        self.requireOwner();
        self.price = msg.newPrice;
        self.isSalable = msg.isSalable;
        self.reply("Price setted".asComment());
    }

    receive(msg: NftTransfer) {
        self.requireOwner();
        self.owner = msg.newOwner;
        self.isSalable = msg.isSalable;
        self.reply("UniqueItem transfered".asComment());
    }

    // receive(msg: SetNewPrice) {
    //     self.requireOwner();
    //     self.price = msg.newPrice;
    //     self.reply("Price setted".asComment());
    // }

    // receive(msg: SetSalable) {
    //     self.requireOwner();
    //     self.isSalable = msg.isSalable;
    //     self.reply("Salable state changed".asComment());
    // }

    // receive("pay") {
    //     require(!self.paid, "Order already paid");
    //     require(context().value >= self.price, "Insufficient payment");

    //     self.paid = true;

    //     let rep: StringBuilder = beginString();
    //     rep.append("Order #");
    //     rep.append(self.index.toString());
    //     rep.append(" completed successfully");

    //     self.reply("Item paid successfully".asComment());
    // }

    // receive("confirm") {
    //     require(sender() == self.buyer, "Only buyer can confirm order");
    //     require(self.paid, "Item price has not been paid yet");

    //     send(SendParameters {
    //         to: self.seller,
    //         value: self.price,
    //         mode: SendIgnoreErrors
    //     });

    //     self.owner = msg.newOwner;
    //     self.isSalable = false;

    //     self.completed = true;

    //     self.reply("UniqueItem transfered".asComment());
    // }

    // receive("refund") {
    //     require(sender() == self.buyer, "Only buyer can refund");
    //     require(!self.completed, "Order already completed" );
    //     require(self.paid, "Order not paid yet");
    //     require(!self.refunded, "Payments already refunded");

    //     self.paid = false;

    //     send(SendParameters {
    //         to: self.buyer,
    //         value: 0,
    //         mode: SendRemainingBalance + SendIgnoreErrors
    //     });
    // }

    receive() {
        // Forward the remaining value in the
        // incoming message back to the sender
        cashback(sender());
    }

    get fun price(): Int {
        return self.price;
    }

    get fun index(): Int {
        return self.index;
    }

    get fun content(): String {
        return self.content;
    }
}
