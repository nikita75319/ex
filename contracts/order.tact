import "./messages";
import "./unique_item";

contract Order {
    seller: Address;
    buyer: Address;
    itemAddress: Address;
    id: Int as uint256;
    price: Int as coins = 0;
    priceSetted: Bool = false;
    // paid: Bool = false;
    completed: Bool = false;
    refunded: Bool = false;

    init(id: Int, seller: Address, buyer: Address, itemAddress: Address) {
        self.seller = seller;
        self.buyer = buyer;
        self.id = id;
        self.itemAddress = itemAddress;
        // self.items = items;
    }

    receive("onDeploy") {
        send(SendParameters {
            to: self.itemAddress,
            value: ton("0.2"),
            body: GetPrice {}.toCell(),
        });
    }

    receive() {
        cashback(sender());
    }

    receive("pay") {
        // require(!self.paid, "Order already paid");
        require(!self.completed, "Order already completed");
        require(self.priceSetted, "Price not setted yet");
        require(context().value >= self.price, "Insufficient payment");
        require(self.refunded, "Item has been refunded for some reason");

        send(SendParameters {
            to: self.itemAddress,
            value: ton("0.2"),
            body: NftTransfer { newOwner: self.buyer, isSalable: false }.toCell(),
        });

        send(SendParameters {
            to: self.seller,
            value: self.price,
            body: OrderCompleted { orderIndex: self.id, buyer: self.buyer, itemAddress: self.itemAddress }.toCell(),
        });

        self.completed = true;
    }

    receive(msg: GetPriceResponse) {
        require(sender() == self.itemAddress, "Invalid sender");
        self.price = msg.price;
        self.priceSetted = true;
    }

    receive("Refund Item") {
        require(sender() == self.seller, "Only seller can refund the item");
        send(SendParameters {
            to: self.itemAddress,
            value: ton("0.2"),
            body: NftTransfer { newOwner: self.buyer, isSalable: false }.toCell(),
        });

        self.refunded = true;
    }

    // receive("confirm") {
    //     require(sender() == self.buyer, "Only buyer can confirm order");
    //     require(self.paid, "Item price has not been paid yet");

    //     send(SendParameters {
    //         to: self.seller,
    //         value: ton("0.02"),
    //         body: OrderPayment {orderIndex: self.id, itemAddress: self.itemAddress, buyer: self.buyer}.toCell(),
    //         mode: SendIgnoreErrors
    //     });
    // }

    // receive(msg: NftTransferSuccess) {
    //     require(self.seller);
    //     require(!self.completed);
    //     require(msg.newOwner == self.buyer, "Wrong new owner");

    //     send(SendParameters {
    //         to: self.seller,
    //         value: self.price,
    //     })
    //     self.completed = true;

    //     self.reply("UniqueItem transfered".asComment());
    // }

    // receive("refund") {
    //     require(sender() == self.buyer, "Only buyer can refund");
    //     require(!self.completed, "Order already completed" );
    //     require(self.paid, "Order not paid yet");
    //     require(!self.refunded, "Payments already refunded");
    //     require(self.priceSetted, "Price not setted yet");

    //     send(SendParameters {
    //         to: self.buyer,
    //         value: self.price,
    //         mode: SendIgnoreErrors
    //     });

    //     self.paid = false;
    //     self.refunded = true;
    // }

    // receive("pay") {
    //     require(!self.paid, "Order already paid");
    //     require(context().value >= self.price, "Insufficient payment");

    //     if (self.isUnique) {
    //         send(SendParameters {
    //         to: self.itemAddress,
    //         value: ton("0.05"),
    //         mode: SendIgnoreErrors,
    //         body: NftTransfer {newOwner: self.buyer}.toCell()
    //         });
    //         self.paid = true;

    //         send(SendParameters{
    //             to: self.seller,
    //             value: self.price,
    //             mode: SendPayGasSeparately
    //         });
    //         self.completed = true;

    //         let rep: StringBuilder = beginString();
    //         rep.append("Order #");
    //         rep.append(self.id.toString());
    //         rep.append(" completed successfully");

    //         send(SendParameters {
    //             to: sender(),
    //             value: 0,
    //             mode: SendRemainingValue + SendIgnoreErrors,
    //             body: rep.toString().asComment(),
    //         });
    //     }
    // }

    // receive("confirm") {
    //     require(sender() == self.buyer, "Only buyer can confirm order");
    //     require(self.paid, "Order has not been paid yet");

    //     self.completed = true;

    //     send(SendParameters {
    //         to: self.seller,
    //         value: 0,
    //         mode: SendRemainingBalance + SendIgnoreErrors
    //     });
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
}
