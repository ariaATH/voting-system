# Voting System

یک قرارداد هوشمند (Smart Contract) ساده برای سیستم رأی‌گیری، نوشته‌شده با Solidity و قابل توسعه/تست با Foundry.

## معرفی

این پروژه امکان ایجاد پیشنهاد (Proposal)، رأی‌گیری روی آن و ثبت رأی‌دهندگان مجاز برای پیشنهادهای خصوصی را فراهم می‌کند. هر پیشنهاد می‌تواند یکی از دو نوع زیر باشد:

- **Public_proposal**: پیشنهاد عمومی — هر کسی می‌تواند رأی دهد.
- **Private_proposal**: پیشنهاد خصوصی — فقط رأی‌دهندگانی که توسط مالک پیشنهاد ثبت‌نام شده‌اند می‌توانند رأی دهند.

## ساختار پروژه

```
voting/
├── src/
│   └── voting.sol        # قرارداد اصلی
├── test/                  # تست‌های Foundry
├── script/                # اسکریپت‌های دیپلوی
├── lib/                   # کتابخانه‌های خارجی
└── foundry.toml           # تنظیمات پروژه
```

## امکانات قرارداد

### ایجاد پیشنهاد
```solidity
createProposal(string _name, string _description, uint256 _starttime, uint256 _endtime, ProposalStatus _status)
```
یک پیشنهاد جدید با بازه زمانی شروع و پایان مشخص ایجاد می‌کند. زمان شروع باید قبل از زمان پایان باشد.

### ثبت رأی‌دهنده (برای پیشنهادهای خصوصی)
```solidity
registerVoters(address _voter, uint256 _proposalId)
```
فقط مالک پیشنهاد می‌تواند رأی‌دهندگان را برای یک پیشنهاد خصوصی ثبت‌نام کند.

### رأی دادن
```solidity
vote(uint256 _proposalId)
```
هر آدرس می‌تواند فقط یک‌بار به هر پیشنهاد رأی دهد و رأی فقط در بازه زمانی فعال پیشنهاد پذیرفته می‌شود. برای پیشنهادهای خصوصی، رأی‌دهنده باید قبلاً ثبت‌نام شده باشد.

### توابع View
- `getProposal(uint256 _proposalId)` — اطلاعات کامل یک پیشنهاد
- `getVoteCount(uint256 _proposalId)` — تعداد آرا
- `isVoterRegistered(address _voter, uint256 _proposalId)` — وضعیت ثبت‌نام رأی‌دهنده
- `hasVoterVoted(address _voter, uint256 _proposalId)` — بررسی رأی‌دادن یک آدرس
- `getProposalStatus(uint256 _proposalId)` — نوع پیشنهاد (عمومی/خصوصی)
- `getProposalOwner(uint256 _proposalId)` — مالک پیشنهاد
- `getProposalTime(uint256 _proposalId)` — زمان شروع و پایان
- `getProposalDescription(uint256 _proposalId)` — توضیحات پیشنهاد
- `getProposalName(uint256 _proposalId)` — نام پیشنهاد

### رویدادها (Events)
- `ProposalCreated(uint256 proposalId, string name, string description, uint256 starttime, uint256 endtime)`
- `Voted(address voter, uint256 proposalId)`
- `VoterRegistered(address voter, uint256 proposalId)`

### خطاهای سفارشی (Custom Errors)
- `ProposalNotActive()`
- `VoterNotRegistered()`
- `VoterAlreadyVoted()`

## پیش‌نیازها

- [Foundry](https://book.getfoundry.sh/getting-started/installation) (forge, cast, anvil)
- Git

## نصب و راه‌اندازی

```bash
git clone https://github.com/<username>/voting-system.git
cd voting-system/voting
forge install
```

## کامپایل پروژه

```bash
forge build
```

## اجرای تست‌ها

```bash
forge test
```

## دیپلوی قرارداد

```bash
forge script script/Deploy.s.sol --rpc-url <RPC_URL> --private-key <PRIVATE_KEY> --broadcast
```

## نکات توسعه آینده

- افزودن قابلیت لغو یا ویرایش پیشنهاد توسط مالک
- اضافه کردن سقف زمانی برای ثبت‌نام رأی‌دهندگان
- استفاده از خطاهای سفارشی (`revert`) به‌جای `require` با رشته متنی برای کاهش مصرف گس

## لایسنس

این پروژه تحت لایسنس [MIT](https://opensource.org/licenses/MIT) منتشر شده است.
