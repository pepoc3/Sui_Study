module nft::my_nft {
    use sui::tx_context::{sender, TxContext};
    use std::string::{utf8, String};
    use sui::transfer::{Self, public_transfer};
    use sui::object::{Self, UID};
    use sui::package;
    use sui::display;

    struct MyNFT has key, store {
        id: UID,
        name: String,
        image_url: String
    }

    /// One-Time-Witness for the module.
    struct MY_NFT has drop {}

    fun init(otw: MY_NFT, ctx: &mut TxContext) {
        let keys = vector[
            utf8(b"name"),
            utf8(b"image_url"),
        ];

        let values = vector[
            utf8(b"{name}"),
            utf8(b"{image_url}"),
        ];

        // Claim the `Publisher` for the package!
        let publisher = package::claim(otw, ctx);

        let display = display::new_with_fields<MyNFT>(
            &publisher, keys, values, ctx
        );

        // Commit first version of `Display` to apply changes.
        display::update_version(&mut display);

        transfer::public_transfer(publisher, sender(ctx));
        transfer::public_transfer(display, sender(ctx));
    }

    public entry fun mint(ctx: &mut TxContext) {
        let name = utf8(b"github:pepoc3_nft");
        let image_url = utf8(b"https://i0.imgs.ovh/2024/03/09/Q9yeu.jpeg");
        let nft = MyNFT {
            id: object::new(ctx),
            name,
            image_url
        };
        public_transfer(nft, sender(ctx));
    }
}