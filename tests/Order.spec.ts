import { Blockchain, SandboxContract, TreasuryContract } from '@ton/sandbox';
import { toNano } from '@ton/core';
import { Order } from '../build/Order/Order_Order';
import '@ton/test-utils';

describe('Order', () => {
    let blockchain: Blockchain;
    let deployer: SandboxContract<TreasuryContract>;
    let order: SandboxContract<Order>;

    beforeEach(async () => {
        blockchain = await Blockchain.create();

        order = blockchain.openContract(await Order.fromInit());

        deployer = await blockchain.treasury('deployer');

        const deployResult = await order.send(
            deployer.getSender(),
            {
                value: toNano('0.05'),
            },
            null,
        );

        expect(deployResult.transactions).toHaveTransaction({
            from: deployer.address,
            to: order.address,
            deploy: true,
            success: true,
        });
    });

    it('should deploy', async () => {
        // the check is done inside beforeEach
        // blockchain and order are ready to use
    });
});
