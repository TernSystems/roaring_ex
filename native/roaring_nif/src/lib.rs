use std::sync::Mutex;

use rustler::{Atom,Resource,ResourceArc};


use roaring::RoaringTreemap;
pub struct RoaringBitsetResource(Mutex<RoaringTreemap>);

#[rustler::resource_impl]
impl Resource for RoaringBitsetResource {
    const IMPLEMENTS_DESTRUCTOR: bool = false;
}

type RoaringBitsetArc = ResourceArc<RoaringBitsetResource>;

mod atoms {
    rustler::atoms! {
        // Common Atoms
        ok,
        error,
        // Resource Atoms
        lock_fail
    }
}

#[rustler::nif]
fn new() -> (Atom, RoaringBitsetArc) {
    let resource = ResourceArc::new(RoaringBitsetResource(Mutex::new(RoaringTreemap::new())));

    (atoms::ok(), resource)
}

#[rustler::nif]
fn to_list(resource: ResourceArc<RoaringBitsetResource>) -> Result<Vec<u64>, Atom> {
    let set = match resource.0.try_lock() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };


    Ok(set.iter().collect())
}

#[rustler::nif]
fn insert(resource: ResourceArc<RoaringBitsetResource>, index: u64) -> Result<Atom, Atom> {
    let mut set = match resource.0.try_lock() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };

    set.insert(index);

    Ok(atoms::ok())
}

#[rustler::nif]
fn contains(resource: ResourceArc<RoaringBitsetResource>, index: u64) ->  Result<bool, Atom> {
    let set = match resource.0.try_lock() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };

    Ok(set.contains(index))
}

#[rustler::nif]
fn intersection(resource1: ResourceArc<RoaringBitsetResource>, resource2: ResourceArc<RoaringBitsetResource>) -> Result<RoaringBitsetArc, Atom> {
    let set1 = match resource1.0.try_lock() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };

    let set2 = match resource2.0.try_lock() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };

    let result = set1.clone() & set2.clone();
    let new_resource = ResourceArc::new(RoaringBitsetResource(Mutex::new(result)));

    Ok(new_resource)
}

#[rustler::nif]
fn union(resource1: ResourceArc<RoaringBitsetResource>, resource2: ResourceArc<RoaringBitsetResource>) -> Result<RoaringBitsetArc, Atom> {
    let set1 = match resource1.0.try_lock() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };

    let set2 = match resource2.0.try_lock() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };

    let result = set1.clone() | set2.clone();
    let new_resource = ResourceArc::new(RoaringBitsetResource(Mutex::new(result)));

    Ok(new_resource)
}
rustler::init!("Elixir.Roaring.NifBridge");
