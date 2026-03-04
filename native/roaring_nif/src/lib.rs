use std::sync::RwLock;

use rustler::types::binary::Binary;
use rustler::types::binary::OwnedBinary;
use rustler::{Atom, Env, Resource, ResourceArc};

use roaring::RoaringBitmap;
use roaring::RoaringTreemap;

// ---------------------------------------------------------------------------
// 64-bit resource (RoaringTreemap)
// ---------------------------------------------------------------------------

pub struct RoaringBitset64Resource(RwLock<RoaringTreemap>);

#[rustler::resource_impl]
impl Resource for RoaringBitset64Resource {
    const IMPLEMENTS_DESTRUCTOR: bool = false;
}

type RoaringBitsetArc = ResourceArc<RoaringBitset64Resource>;

// ---------------------------------------------------------------------------
// 32-bit resource (RoaringBitmap)
// ---------------------------------------------------------------------------

pub struct RoaringBitset32Resource(RwLock<RoaringBitmap>);

#[rustler::resource_impl]
impl Resource for RoaringBitset32Resource {
    const IMPLEMENTS_DESTRUCTOR: bool = false;
}

type RoaringBitset32Arc = ResourceArc<RoaringBitset32Resource>;

// ---------------------------------------------------------------------------
// Atoms
// ---------------------------------------------------------------------------

mod atoms {
    rustler::atoms! {
        // Common Atoms
        ok,
        error,
        // Resource Atoms
        lock_fail
    }
}

// ---------------------------------------------------------------------------
// 64-bit NIFs
// ---------------------------------------------------------------------------

#[rustler::nif]
fn new_64() -> (Atom, RoaringBitsetArc) {
    let resource = ResourceArc::new(RoaringBitset64Resource(RwLock::new(RoaringTreemap::new())));
    (atoms::ok(), resource)
}

#[rustler::nif]
fn to_list_64(resource: ResourceArc<RoaringBitset64Resource>) -> Result<Vec<u64>, Atom> {
    let set = match resource.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    Ok(set.iter().collect())
}

#[rustler::nif]
fn insert_64(resource: ResourceArc<RoaringBitset64Resource>, index: u64) -> Result<Atom, Atom> {
    let mut set = match resource.0.try_write() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    set.insert(index);
    Ok(atoms::ok())
}

#[rustler::nif]
fn remove_64(resource: ResourceArc<RoaringBitset64Resource>, index: u64) -> Result<Atom, Atom> {
    let mut set = match resource.0.try_write() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    set.remove(index);
    Ok(atoms::ok())
}

#[rustler::nif]
fn contains_64(resource: ResourceArc<RoaringBitset64Resource>, index: u64) -> Result<bool, Atom> {
    let set = match resource.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    Ok(set.contains(index))
}

#[rustler::nif]
fn intersection_64(
    resource1: ResourceArc<RoaringBitset64Resource>,
    resource2: ResourceArc<RoaringBitset64Resource>,
) -> Result<RoaringBitsetArc, Atom> {
    let set1 = match resource1.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    let set2 = match resource2.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    let result = set1.clone() & set2.clone();
    Ok(ResourceArc::new(RoaringBitset64Resource(RwLock::new(
        result,
    ))))
}

#[rustler::nif]
fn union_64(
    resource1: ResourceArc<RoaringBitset64Resource>,
    resource2: ResourceArc<RoaringBitset64Resource>,
) -> Result<RoaringBitsetArc, Atom> {
    let set1 = match resource1.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    let set2 = match resource2.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    let result = set1.clone() | set2.clone();
    Ok(ResourceArc::new(RoaringBitset64Resource(RwLock::new(
        result,
    ))))
}

#[rustler::nif]
fn xor_64(
    resource1: ResourceArc<RoaringBitset64Resource>,
    resource2: ResourceArc<RoaringBitset64Resource>,
) -> Result<RoaringBitsetArc, Atom> {
    let set1 = match resource1.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    let set2 = match resource2.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    let result = set1.clone() ^ set2.clone();
    Ok(ResourceArc::new(RoaringBitset64Resource(RwLock::new(
        result,
    ))))
}

#[rustler::nif]
fn difference_64(
    resource1: ResourceArc<RoaringBitset64Resource>,
    resource2: ResourceArc<RoaringBitset64Resource>,
) -> Result<RoaringBitsetArc, Atom> {
    let set1 = match resource1.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    let set2 = match resource2.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    let result = set1.clone() - set2.clone();
    Ok(ResourceArc::new(RoaringBitset64Resource(RwLock::new(
        result,
    ))))
}

#[rustler::nif]
fn serialize_64(env: Env, resource: ResourceArc<RoaringBitset64Resource>) -> Result<Binary, Atom> {
    let set = match resource.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    let mut bytes = vec![];
    set.serialize_into(&mut bytes).unwrap();
    let mut binary: OwnedBinary = OwnedBinary::new(bytes.len()).unwrap();
    binary.as_mut_slice().copy_from_slice(&bytes);
    Ok(binary.release(env))
}

#[rustler::nif]
fn deserialize_64(binary: Binary) -> Result<RoaringBitsetArc, Atom> {
    let buffer = binary.as_slice();
    let set: RoaringTreemap = RoaringTreemap::deserialize_from(&buffer[..]).unwrap();
    Ok(ResourceArc::new(RoaringBitset64Resource(RwLock::new(set))))
}

#[rustler::nif]
fn equal_64(
    resource1: ResourceArc<RoaringBitset64Resource>,
    resource2: ResourceArc<RoaringBitset64Resource>,
) -> Result<bool, Atom> {
    let set1 = match resource1.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    let set2 = match resource2.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    Ok(set1.symmetric_difference_len(&set2) == 0)
}

#[rustler::nif]
fn size_64(resource: ResourceArc<RoaringBitset64Resource>) -> Result<u64, Atom> {
    let set = match resource.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    Ok(set.len())
}

// ---------------------------------------------------------------------------
// 32-bit NIFs
// ---------------------------------------------------------------------------

#[rustler::nif]
fn new_32() -> (Atom, RoaringBitset32Arc) {
    let resource = ResourceArc::new(RoaringBitset32Resource(RwLock::new(RoaringBitmap::new())));
    (atoms::ok(), resource)
}

#[rustler::nif]
fn to_list_32(resource: ResourceArc<RoaringBitset32Resource>) -> Result<Vec<u32>, Atom> {
    let set = match resource.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    Ok(set.iter().collect())
}

#[rustler::nif]
fn insert_32(resource: ResourceArc<RoaringBitset32Resource>, index: u32) -> Result<Atom, Atom> {
    let mut set = match resource.0.try_write() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    set.insert(index);
    Ok(atoms::ok())
}

#[rustler::nif]
fn remove_32(resource: ResourceArc<RoaringBitset32Resource>, index: u32) -> Result<Atom, Atom> {
    let mut set = match resource.0.try_write() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    set.remove(index);
    Ok(atoms::ok())
}

#[rustler::nif]
fn contains_32(resource: ResourceArc<RoaringBitset32Resource>, index: u32) -> Result<bool, Atom> {
    let set = match resource.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    Ok(set.contains(index))
}

#[rustler::nif]
fn intersection_32(
    resource1: ResourceArc<RoaringBitset32Resource>,
    resource2: ResourceArc<RoaringBitset32Resource>,
) -> Result<RoaringBitset32Arc, Atom> {
    let set1 = match resource1.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    let set2 = match resource2.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    let result = set1.clone() & set2.clone();
    Ok(ResourceArc::new(RoaringBitset32Resource(RwLock::new(
        result,
    ))))
}

#[rustler::nif]
fn union_32(
    resource1: ResourceArc<RoaringBitset32Resource>,
    resource2: ResourceArc<RoaringBitset32Resource>,
) -> Result<RoaringBitset32Arc, Atom> {
    let set1 = match resource1.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    let set2 = match resource2.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    let result = set1.clone() | set2.clone();
    Ok(ResourceArc::new(RoaringBitset32Resource(RwLock::new(
        result,
    ))))
}

#[rustler::nif]
fn xor_32(
    resource1: ResourceArc<RoaringBitset32Resource>,
    resource2: ResourceArc<RoaringBitset32Resource>,
) -> Result<RoaringBitset32Arc, Atom> {
    let set1 = match resource1.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    let set2 = match resource2.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    let result = set1.clone() ^ set2.clone();
    Ok(ResourceArc::new(RoaringBitset32Resource(RwLock::new(
        result,
    ))))
}

#[rustler::nif]
fn difference_32(
    resource1: ResourceArc<RoaringBitset32Resource>,
    resource2: ResourceArc<RoaringBitset32Resource>,
) -> Result<RoaringBitset32Arc, Atom> {
    let set1 = match resource1.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    let set2 = match resource2.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    let result = set1.clone() - set2.clone();
    Ok(ResourceArc::new(RoaringBitset32Resource(RwLock::new(
        result,
    ))))
}

#[rustler::nif]
fn serialize_32(env: Env, resource: ResourceArc<RoaringBitset32Resource>) -> Result<Binary, Atom> {
    let set = match resource.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    let mut bytes = vec![];
    set.serialize_into(&mut bytes).unwrap();
    let mut binary: OwnedBinary = OwnedBinary::new(bytes.len()).unwrap();
    binary.as_mut_slice().copy_from_slice(&bytes);
    Ok(binary.release(env))
}

#[rustler::nif]
fn deserialize_32(binary: Binary) -> Result<RoaringBitset32Arc, Atom> {
    let buffer = binary.as_slice();
    let set: RoaringBitmap = RoaringBitmap::deserialize_from(&buffer[..]).unwrap();
    Ok(ResourceArc::new(RoaringBitset32Resource(RwLock::new(set))))
}

#[rustler::nif]
fn equal_32(
    resource1: ResourceArc<RoaringBitset32Resource>,
    resource2: ResourceArc<RoaringBitset32Resource>,
) -> Result<bool, Atom> {
    let set1 = match resource1.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    let set2 = match resource2.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    Ok(set1.symmetric_difference_len(&set2) == 0)
}

#[rustler::nif]
fn size_32(resource: ResourceArc<RoaringBitset32Resource>) -> Result<u64, Atom> {
    let set = match resource.0.try_read() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };
    Ok(set.len())
}

rustler::init!("Elixir.RoaringBitset.NifBridge");
