import re
from playwright.sync_api import Playwright, sync_playwright, expect


def run(playwright: Playwright) -> None:
    browser = playwright.chromium.launch(headless=False)
    context = browser.new_context()
    page = context.new_page()
    page.goto("https://chrisweise.com/")
    page.get_by_role("link", name="Projects").click()
    page.get_by_role("link", name="Skills").click()
    page.get_by_role("link", name="Certifications").click()
    page.get_by_role("link", name="Work").click()
    page.get_by_role("link", name="Education").click()
    page.get_by_role("link", name="About").click()
    with page.expect_popup() as page1_info:
        page.locator("#about").get_by_role("link").first.click()
    page1 = page1_info.value
    with page.expect_popup() as page2_info:
        page.locator("#about").get_by_role("link").nth(1).click()
    page2 = page2_info.value
    with page.expect_popup() as page3_info:
        page.locator("#about").get_by_role("link").nth(2).click()
    page3 = page3_info.value
    page.get_by_text("This page has been visited").click()
    with page.expect_popup() as page4_info:
        page.get_by_role("link", name="Cloud Resume Challenge").click()
    page4 = page4_info.value
    with page.expect_popup() as page5_info:
        page.get_by_role("link", name="Python").click()
    page5 = page5_info.value
    with page.expect_popup() as page6_info:
        page.get_by_role("link", name="Blogs").click()
    page6 = page6_info.value

    # ---------------------
    context.close()
    browser.close()
    print('Test was a success.')
    # Printing out test was a success to confirm test went through successfully.

with sync_playwright() as playwright:
    run(playwright)


