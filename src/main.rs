#![allow(non_snake_case)]

use std::{env, io, os::unix::process::CommandExt, process::Command};
use syslog::{unix, Facility::LOG_AUTH, Formatter3164};

fn main() -> io::Result<()> {
    if env::args().len() == 1 {
        eprintln!("usage: {} <command> [args]", env::args().nth(0).unwrap());
        return Ok(());
    }

    let program = env::args().nth(1).unwrap();
    let args = env::args().skip(2).collect::<Vec<String>>();
    let mut writer = unix(Formatter3164 {
        facility: LOG_AUTH,
        hostname: None,
        process: "🥺".into(),
        pid: 0,
    })
    .unwrap();
    writer
        .err(format!("running {:?} {:?}", program, args))
        .unwrap();

    Err(Command::new(program).args(args).uid(0).gid(0).exec().into())
}
