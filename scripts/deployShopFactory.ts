import { toNano } from '@ton/core';
import { ShopFactory } from '../build/ShopFactory/tact_ShopFactory';
import { NetworkProvider } from '@ton/blueprint';

export async function run(provider: NetworkProvider) {
    const sender = provider.sender();
    const shopFactory = provider.open(await ShopFactory.fromInit(sender.address!));

    await shopFactory.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        null,
    );

    await provider.waitForDeploy(shopFactory.address);

    // run methods on `shopFactory`
}
