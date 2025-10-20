import { toNano } from '@ton/core';
import { UsersFactory } from '../build/UsersFactory/UsersFactory_UsersFactory';
import { NetworkProvider } from '@ton/blueprint';

export async function run(provider: NetworkProvider) {
    const usersFactory = provider.open(await UsersFactory.fromInit());

    await usersFactory.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        null,
    );

    await provider.waitForDeploy(usersFactory.address);

    // run methods on `usersFactory`
}
