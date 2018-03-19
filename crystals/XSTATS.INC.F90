module xstats_mod
implicit none

    integer ipread , ipwrit , icache , ncache(24)
    integer fstcpu,jmode,ncall,jhash(12)
    real oldcpu,oldelp

    common /xstats/ ipread , ipwrit , icache , ncache, &
    &   oldcpu,oldelp,fstcpu,jmode,ncall,jhash

end module
