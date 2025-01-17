
<script>
    import { onMount } from "svelte";
    
    onMount(() => {

        //TODO: fix later 
        //UPDATE: i forgot wtf this is supposed to be doing but im not gonna delete it in case i someday care about it
        let observer;
        document.addEventListener("DOMContentLoaded", () => {
            observer = new IntersectionObserver((entries) => {
                entries.forEach((entry) => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add("translate-y-8"); 
                        observer.unobserve(entry.target);
                    }
                });
            }, {
                threshold: .75,
            });
            const lockTop = document.querySelector("top");
            console.log(lockTop);
            observer.observe(lockTop);
        });
    });

</script>


<div class="h-screen bg-gray-950">

    <div class="relative flex justify-center">
        <p class="mt-32 text-8xl text-white font-serif">Disbord</p>
    </div>


    <div class="flex justify-center ">
        <p class="text-5xl font-serif -translate-x-48 w-5 text-white mt-32">Your Secure Messaging Platform</p>

        <div class="relative mt-10 translate-x-48">
            <svg width="200" height="308" viewBox="0 0 200 308" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path id="top" d="M24 150V138.101V123.821V118.262V83.9787C24 -16.8588 176 -17.7926 176 83.9787V92.7472V96.2784V103.196" stroke="#8AEAFF" stroke-width="15"
                class="transition ease-linear translate-y-10"/>
                <rect id="base" y="142" width="200" height="166" rx="14" fill="#6549FF"/>
            </svg>
        </div>
    </div>

    <div class="flex justify-center">
        <a href="/home" class="mt-24 text-xl text-gray-200 bg-blue-600 p-5 rounded-md font-bold shadow-[0_0_180px_80px_rgba(49,46,129,1)]">Get Started</a>
    </div>
</div>

<div class="h-screen bg-white">
    <div class="flex flex-col items-center">
        <div class="mt-24 text-5xl font-serif">Trusted By Companies You Know</div>
        <img src="/logo-sprite-x2-v3.jpg" alt="loads of massive companies" class="mt-36"/>
    </div>
</div>