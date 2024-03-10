module Counter::counter {
    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};

    struct Counter has key {
        id: UID,
        value: u64,
    }

    entry public fun getCounter(ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        let counter_obj = Counter {
            id: object::new(ctx),//这里创建了一个全局唯一的ID
            value: 0
        };
        //转让counter_obj所有权给sender
        transfer::transfer(counter_obj, sender);
    }
    public entry fun incr(counter: &mut Counter) {
        counter.value = counter.value + 1;
    } 
}