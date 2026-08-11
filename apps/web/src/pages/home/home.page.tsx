import { HomeCta } from "./home-cta";
import { HomeFaq } from "./home-faq";
import { HomeFeatures } from "./home-features";
import { HomeHero } from "./home-hero";
import { HomePricing } from "./home-pricing";
import { HomeTestimonials } from "./home-testimonials";

export function HomePage() {
  return (
    <>
      <HomeHero />
      <HomeFeatures />
      <HomePricing />
      <HomeTestimonials />
      <HomeFaq />
      <HomeCta />
    </>
  );
}
