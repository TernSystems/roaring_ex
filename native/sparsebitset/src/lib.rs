use std::sync::Mutex;

use rustler::{Atom,Resource,ResourceArc};


use roaring::RoaringTreemap;
pub struct SparseBitsetResource(Mutex<RoaringTreemap>);

#[rustler::resource_impl]
impl Resource for SparseBitsetResource {
    const IMPLEMENTS_DESTRUCTOR: bool = false;
}

type SparseBitsetArc = ResourceArc<SparseBitsetResource>;

mod atoms {
    rustler::atoms! {
        // Common Atoms
        ok,
        error,

        // Resource Atoms
        bad_reference,
        lock_fail,

        // Success Atoms
        added,
        duplicate,
        removed,

        // Error Atoms
        unsupported_type,
        not_found,
        index_out_of_bounds,
        max_bucket_size_exceeded,
    }
}

#[rustler::nif]
fn new() -> (Atom, SparseBitsetArc) {
    let resource = ResourceArc::new(SparseBitsetResource(Mutex::new(RoaringTreemap::new())));

    (atoms::ok(), resource)
}

#[rustler::nif]
fn to_list(resource: ResourceArc<SparseBitsetResource>) -> Result<Vec<u64>, Atom> {
    let set = match resource.0.try_lock() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };


    Ok(set.iter().collect())
}

#[rustler::nif]
fn insert(resource: ResourceArc<SparseBitsetResource>, index: u64) -> Result<Atom, Atom> {
    let mut set = match resource.0.try_lock() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };

    set.insert(index);

    Ok(atoms::ok())
}

#[rustler::nif]
fn contains(resource: ResourceArc<SparseBitsetResource>, index: u64) ->  Result<bool, Atom> {
    let set = match resource.0.try_lock() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };

    Ok(set.contains(index))
}

#[rustler::nif]
fn intersection(resource1: ResourceArc<SparseBitsetResource>, resource2: ResourceArc<SparseBitsetResource>) -> Result<SparseBitsetArc, Atom> {
    let set1 = match resource1.0.try_lock() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };

    let set2 = match resource2.0.try_lock() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };

    let result = set1.clone() & set2.clone();
    let new_resource = ResourceArc::new(SparseBitsetResource(Mutex::new(result)));

    Ok(new_resource)
}

#[rustler::nif]
fn union(resource1: ResourceArc<SparseBitsetResource>, resource2: ResourceArc<SparseBitsetResource>) -> Result<SparseBitsetArc, Atom> {
    let set1 = match resource1.0.try_lock() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };

    let set2 = match resource2.0.try_lock() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };

    let result = set1.clone() | set2.clone();
    let new_resource = ResourceArc::new(SparseBitsetResource(Mutex::new(result)));

    Ok(new_resource)
}
rustler::init!("Elixir.SparseBitset.NifBridge");
