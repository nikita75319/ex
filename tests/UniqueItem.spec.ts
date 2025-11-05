import { Blockchain, SandboxContract, TreasuryContract } from '@ton/sandbox';
import { toNano } from '@ton/core';
import { UniqueItem } from '../build/UniqueItem/UniqueItem_UniqueItem';
import '@ton/test-utils';

describe('UniqueItem', () => {
    let blockchain: Blockchain;
    let deployer: SandboxContract<TreasuryContract>;
    let uniqueItem: SandboxContract<UniqueItem>;

    beforeEach(async () => {
        blockchain = await Blockchain.create();

        uniqueItem = blockchain.openContract(await UniqueItem.fromInit());

        deployer = await blockchain.treasury('deployer');

        const deployResult = await uniqueItem.send(
            deployer.getSender(),
            {
                value: toNano('0.05'),
            },
            null,
        );

        expect(deployResult.transactions).toHaveTransaction({
            from: deployer.address,
            to: uniqueItem.address,
            deploy: true,
            success: true,
        });
    });

    it('should deploy', async () => {
        // the check is done inside beforeEach
        // blockchain and uniqueItem are ready to use
    });
});
